import 'dart:convert';
import 'dart:typed_data';

import 'package:chapa_tu_aula/components/shared/user_info.dart';
import 'package:chapa_tu_aula/main.dart';
import 'package:flutter/material.dart';
import 'package:chapa_tu_aula/screens/home.dart';
import 'package:chapa_tu_aula/screens/chat.dart';
import 'package:chapa_tu_aula/screens/teachers.dart';


class NavDrawer extends StatefulWidget {


  NavDrawer({super.key});

  @override
  _MyNavDrawerPageState createState() {
    return _MyNavDrawerPageState();
  }
}

class _MyNavDrawerPageState extends State<NavDrawer> {
  UserInfo userInfo = UserInfo();
  late MemoryImage userPhoto;

  @override
  void initState() {
    super.initState();
    createUserPhoto();
  }

  @override
  Widget build(BuildContext context) {
    var cabecera = DrawerHeader(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/FISI.png'),
        fit: BoxFit.fill,
      )),
      child: Center(
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: CircleAvatar(
                  backgroundImage: userPhoto,
                )),
            Expanded(
              flex: 6,
              child: Text(
                "Buenos días,\n ${userInfo.name} ",
                style: const TextStyle(
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
                ),
              ));
            }),
        const Divider(
          color: Colors.grey,
        ),
        ListTile(
            title: const Text("Chat"),
            leading: const Icon(
              (Icons.chat),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => Chat()));
            }),
        const Divider(
          color: Colors.grey,
        ),
        ListTile(
            title: const Text("Profesores"),
            leading: const Icon(
              (Icons.note_add),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => TeachersScreen()));
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

  void createUserPhoto(){
    Uint8List userPhotoBytes = base64Decode(userInfo.userPhotoBytes!);
    setState(() {
    userPhoto = MemoryImage(userPhotoBytes);
    });

  }


}
