import 'dart:convert';
import 'dart:typed_data';

import 'package:chapa_tu_aula/main.dart';
import 'package:flutter/material.dart';
import 'package:chapa_tu_aula/screens/home.dart';

class NavDrawer extends StatefulWidget {
  Map<String, dynamic> responseData;

  Map<String, String> cookies;

  NavDrawer({super.key, required this.responseData, required this.cookies});

  @override
  _MyNavDrawerPageState createState() {
    return _MyNavDrawerPageState();
  }
}

class _MyNavDrawerPageState extends State<NavDrawer> {
  late String userName;
  late MemoryImage userPhoto;

  @override
  Widget build(BuildContext context) {
    getUserInfo();
    var cabecera = DrawerHeader(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/FISI.png'),
        fit: BoxFit.fill,
      )),
      child: Center(
        child: Row(
          children: [
            /*
            *
            Expanded(
                flex: 2,
                child: CircleAvatar(
                  //backgroundImage: userPhoto,

                )),
             */
            Expanded(
              flex: 6,
              child: Text(
                "Buenos días,\n ${userName} ",
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 3.0,
                    )
                  ],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    var verlista = Column(children: [
      Expanded(
          child: ListView(children: [
        cabecera,
        ListTile(
            title: const Text("Inicio"),
            leading: const Icon(
              (Icons.home),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HomePage(
                    responseData: widget.responseData, cookies: widget.cookies),
              ));
            }),
        const Divider(
          color: Colors.grey,
        ),


      ])),
      ListTile(
        title: const Text("Cerrar sesión"),
        leading: const Icon(Icons.logout),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => MyApp()));
        },
      ),
    ]);

    return Drawer(child: verlista);
  }

  void getUserInfo() {
    userName = widget.responseData["fullName"];
    //Uint8List userPhotoBytes = base64Decode(widget.responseData['dto']['foto']);
    //userPhoto = MemoryImage(userPhotoBytes);
  }
}
