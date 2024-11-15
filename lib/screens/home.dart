import 'dart:convert';
import 'dart:typed_data';
import 'package:chapa_tu_aula/screens/classroms_list.dart';
import 'package:flutter/material.dart';
import 'package:chapa_tu_aula/components/shared/navDrawer.dart';
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
          'CHAPA TU AULA',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: userPhoto,
            ),
            title: const Text('Buenos días'),
            subtitle: Text(userName),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                backgroundColor: const Color(0xFFF1F1DB),
                foregroundColor: Colors.black,
                fixedSize: const Size(370, 280),
                alignment: Alignment.center,
                textStyle: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PROGRAMACIÓN',
                ),
                SizedBox(height: 10),
                Icon(
                  Icons.access_time,
                  size: 100,
                ),
                SizedBox(height: 10),
                Text(
                  'DIARIA',
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClassromsList(
                          responseData: widget.responseData,
                          cookies: widget.cookies)));
            },
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                backgroundColor: const Color(0xFF5359DC),
                foregroundColor: Colors.white,
                fixedSize: const Size(370, 280),
                alignment: Alignment.center,
                textStyle: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PROGRAMACIÓN',
                ),
                SizedBox(height: 10),
                Icon(
                  Icons.assignment_ind,
                  size: 100,
                ),
                SizedBox(height: 10),
                Text(
                  'PERSONAL',
                ),
              ],
            ),
            onPressed: () {
              //Navigator.push(context, route)
            },
          ),
        ],
      )),
      drawer: NavDrawer(
        responseData: widget.responseData,
        cookies: widget.cookies,
      ),
    );
  }

  void getUserInfo() {
    var userNameFromAPI =
        "${widget.responseData['dto']['nomAlumno']} ${widget.responseData['dto']['apePaterno']} ${widget.responseData['dto']['apeMaterno']}"
            .toString();
    userName = utf8.decode(userNameFromAPI.runes.toList());
    userDegree =
        widget.responseData['dto']['desEscuela'].split(' ').last.toUpperCase();
    userPlan = widget.responseData['dto']['codPlan'];

    Uint8List userPhotoBytes = base64Decode(widget.responseData['dto']['foto']);
    userPhoto = MemoryImage(userPhotoBytes);
  }
}
