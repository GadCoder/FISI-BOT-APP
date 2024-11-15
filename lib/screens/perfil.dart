import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:chapa_tu_aula/components/shared/navDrawer.dart';

class ProfilePage extends StatefulWidget {
  Map<String, dynamic> responseData;
  Map<String, String> cookies;

  ProfilePage({super.key, required this.responseData, required this.cookies});

  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> userInfo;
  late String userName;
  late MemoryImage userPhoto;
  late String userCode;
  late String userGrade;

  @override
  Widget build(BuildContext context) {
    getUserInfo();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(flex: 2, child: _TopPortion(userPhoto: userPhoto)),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    userName,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Estudiante",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w100,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            userCode,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          Text(
                            "########",
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(width: 20.0),
                      Column(children: [
                        Text(
                          userGrade as String,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        Text(
                          "Promedio",
                          style: TextStyle(
                              fontWeight: FontWeight.w100, color: Colors.grey),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                      height: 300,
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          Container(
                              height: 50,
                              child: Column(children: [
                                Text(
                                  "Facultad",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "20 - INGENIERÍA DE SISTEMAS E INFORMÁTICA",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple),
                                ),
                              ])),
                          Divider(),
                          Container(
                              height: 50,
                              child: Column(children: [
                                Text(
                                  "Programa",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "2 - E.P. de Ingeniería de Software",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple),
                                ),
                              ])),
                          Divider(),
                          Container(
                              height: 50,
                              child: Column(children: [
                                Text(
                                  "Periodo Académico",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "2024-1",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple),
                                ),
                              ])),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: NavDrawer(
        responseData: widget.responseData,
        cookies: widget.cookies,
      ),
    );
  }

  void getUserInfo() {
    userName =
        "${widget.responseData['dto']['nomAlumno']} ${widget.responseData['dto']['apePaterno']}${widget.responseData['dto']['apeMaterno']}";
    Uint8List userPhotoBytes = base64Decode(widget.responseData['dto']['foto']);
    userPhoto = MemoryImage(userPhotoBytes);
    userCode = widget.responseData['dto']['codAlumno'];
    userGrade = widget.responseData['dto']['ponderado'].toString();
  }
}

class _TopPortion extends StatelessWidget {
  final MemoryImage userPhoto;

  const _TopPortion({super.key, required this.userPhoto});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(fit: BoxFit.fill, image: userPhoto),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
