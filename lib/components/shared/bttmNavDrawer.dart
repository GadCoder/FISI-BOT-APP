import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:chapa_tu_aula/screens/home.dart';
import 'package:chapa_tu_aula/main.dart';

class CustomBottomNavigationBar extends StatefulWidget {

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home_rounded, size: 36),
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(responseData: {}, cookies: {},),
                  ));
                },
              ),
              IconButton(
                icon: Icon(Icons.history_sharp, size: 36),
                onPressed: () {
                  print('Log');
                },
              ),
              SizedBox(width: 50),
              IconButton(
                icon: Icon(Icons.calendar_month, size: 36),
                onPressed: () {
                  print('Calendario??? Programación');
                },
              ),
              IconButton(
                icon: Icon(Icons.person, size: 36),
                onPressed: () {
                  print('Perfil');
                }
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width / 2 - 35,
          child: SizedBox(
            width: 70.0,
            height: 70.0,
            child: FloatingActionButton(
              onPressed: () {
                print('CHAT');
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.wechat_sharp,
                size: 45,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

}