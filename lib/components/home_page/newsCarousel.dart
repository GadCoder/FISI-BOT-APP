import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';


class NewsCarousel extends StatefulWidget {
  @override
  _NewsCarouselState createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  List<Map<String, String>> _carouselData = [];
  PageController _pageController = PageController();



  @override
  void initState() {
    super.initState();
    _fetchDataFromAPI();
    loadModel();
  }

  Future<void> loadModel() async {
  }

  Future<void> _fetchDataFromAPI() async {
    final url = 'https://api-tas.gadsw.dev/data-element/get-latest-elements-from-type/?type=news';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = json.decode(utf8.decode(response.bodyBytes));

        setState(() {
          _carouselData = data.map((item) {
            return {
              'title': item['title'].toString(),
              'content': item['content'].toString(),
              'created_at': item['created_at'].toString(),
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  String cleanText(String text) {
    return text.trim().replaceAll(RegExp(r'[\n\r]+'), ' ');
  }

  Future<String> resumirTexto(String texto) async {
    try {
      final url2 = Uri.parse('https://ba96-34-83-103-173.ngrok-free.app/resumidor');


      final cleanedText = cleanText(texto);


      final queryParams = {
        'input_text': cleanedText,
      };


      final fullUrl = url2.replace(queryParameters: queryParams);

      print('Request URL: $fullUrl');

      final response = await http.post(
        fullUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String summary = utf8.decode(response.bodyBytes);
        //final summary = response.body;
        return summary;
      } else {
        print('Failed to summarize text: ${response.statusCode}');
        print('Response body: ${response.body}');
        return texto;
      }
    } catch (e) {
      print('Error summarizing text: $e');
      return texto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _carouselData.isEmpty
        ? Center(child: CircularProgressIndicator())
        : PageView.builder(
      controller: _pageController,
      itemCount: _carouselData.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _carouselData[index];
        return FutureBuilder<String>(
          future: resumirTexto(item['content']!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            String summarizedContent = snapshot.data ?? item['content']!;

            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item['title']!,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      summarizedContent,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _formatDate(item['created_at']!),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}