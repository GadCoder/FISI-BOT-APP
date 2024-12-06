import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chapa_tu_aula/components/shared/navDrawer.dart';
import 'package:chapa_tu_aula/components/shared/bttmNavDrawer.dart';
import 'package:chapa_tu_aula/components/home_page/newsCarousel.dart';

import 'package:chapa_tu_aula/services/api_sum.dart';
import 'package:logger/logger.dart';


class HomePage extends StatefulWidget {
  Map<String, dynamic> responseData;
  Map<String, String> cookies;

  HomePage({super.key, required this.responseData, required this.cookies});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> userInfo;
  late String userName;
  late MemoryImage userPhoto;
  late String userDegree;
  late String userPlan;
  final apiSUM = SumAPI();

  var logger = Logger();



  @override
  Widget build(BuildContext context) {
    getUserInfo();
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'FISIBOT',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body: Center(

          child: Column(
            children: [

              /*FractionallySizedBox(
                heightFactor: 0.8,
               child: NewsCarousel(),
             ),*/
            Expanded(child: NewsCarousel(),)
          ],
      )),

      drawer: NavDrawer(
        responseData: widget.responseData,
        cookies: widget.cookies,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  void getUserInfo() {
    var userNameFromAPI = widget.responseData["fullName"].toString();
    userName = utf8.decode(userNameFromAPI.runes.toList());
    //userDegree =
    //    widget.responseData['dto']['desEscuela'].split(' ').last.toUpperCase();
    userDegree = "INGENIERÍA DE SOFTWARE";
    // userPlan = widget.responseData['dto']['codPlan'];
    userPlan = "2018";

    //Uint8List userPhotoBytes = base64Decode(widget.responseData['dto']['foto']);
    //userPhoto = MemoryImage(userPhotoBytes);
  }
}

