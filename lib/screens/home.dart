import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chapa_tu_aula/components/shared/navDrawer.dart';
import 'package:chapa_tu_aula/services/api_sum.dart';
import 'package:logger/logger.dart';

import '../components/home_page/newsCarousel.dart';
import '../components/shared/bttmNavDrawer.dart';
import '../components/shared/user_info.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required Map responseData, required Map cookies});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserInfo userInfo = UserInfo();
  late MemoryImage userPhoto;
  final apiSUM = SumAPI();
  bool infoIsFetched = false;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'FISI BOT',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: userInfo.name == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  Expanded(child: NewsCarousel(),
                  )
                ],
            )),
      drawer: NavDrawer(responseData: {}, cookies: {},),
      bottomNavigationBar: CustomBottomNavigationBar(responseData: {}, cookies: {},),
    );
  }

  void getUserInfo() async {
    if(userInfo.studentCode != null){
      createUserPhoto();
      return;
    }
    Future<dynamic> request = apiSUM.getPersonalInfo();
    Map<String, dynamic>? data = await request;
    if (data == null) {
      logger.d("ERROR GETTING USER INFO");
      return;
    }
    String tempLastName = "${data["apePaterno"]} ${data["apeMaterno"]}";
    setState(() {
      userInfo.name = utf8.decode(data["nombre"].toString().runes.toList());
      userInfo.lastName = utf8.decode(tempLastName.runes.toList());
      userInfo.studentCode = data["codAlumno"].toString();
      userInfo.degree = utf8.decode(data["desEscuela"].toString().runes.toList());
      userInfo.userPhotoBytes = data["foto"];
      createUserPhoto();

    });


  }
  void createUserPhoto(){
    Uint8List userPhotoBytes = base64Decode(userInfo.userPhotoBytes!);
    userPhoto = MemoryImage(userPhotoBytes);
  }
}
