import 'dart:html';

import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final List messages;
  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}
class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: widget.messages[index]['isUserMessage']
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: widget.messages[index]['isUserMessage']
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(
                            widget.messages[index]['isUserMessage'] ? 0 : 20),
                        topLeft: Radius.circular(
                            widget.messages[index]['isUserMessage'] ? 20 : 0),
                      ),
                      color: widget.messages[index]['isUserMessage']
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
                    constraints: BoxConstraints(maxWidth: w * 2 / 3),
                    child: Text(
                      widget.messages[index]['message'],
                      style: TextStyle(
                        color: widget.messages[index]['isUserMessage']
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // Boton de reportar solo si es el bot y no es el mensaje de bienvenida
              if (!widget.messages[index]['isUserMessage'] && index > 0)
                Row(
                  mainAxisAlignment: widget.messages[index]['isUserMessage']
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.report),
                      onPressed: () {
                        reportMessage(index);
                      },
                    ),
                    Text('Reportar'),
                  ],
                ),
            ],
          ),
        );
      },
      separatorBuilder: (_, i) => Padding(padding: EdgeInsets.only(top: 5)),
      itemCount: widget.messages.length,
    );
  }

  void reportMessage(int index) {
    // Logic to handle reporting the message
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reportar'),
          content: Text('Ayúdanos a mejorar, ¿Esta respuesta fue satisfactoria?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}