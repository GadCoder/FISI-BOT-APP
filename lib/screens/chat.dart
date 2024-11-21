import 'package:flutter/material.dart';
import 'messages.dart'; 

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}
class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();

  // Lista de mensajes y si es userMessage[] 
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    // Primer Mesaje de Saludo
    sendWelcomeMessage();
  }

  void sendWelcomeMessage() {
    setState(() {
      messages.add({
        'message': 'Bienvenido! Soy un CHATBOT, puedes preguntarme sobre asuntos relacionados a la Universidad como: Tramites, Profesores y Aulas.',
        'isUserMessage': false,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Ayuda'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MessagesScreen(messages: messages), // Pasar lista de mensajes
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Agregar mensajes de bot y usuarios
  void sendMessage(String text) {
    if (text.isEmpty) return; // No enviar mensajes vacios

    setState(() {
      // Agregar mensaje de usuario
      messages.add({'message': text, 'isUserMessage': true});

      // Aqui iria lo de BOT
      String botResponse = 'Me preguntaste: $text'; // Logica del bot
      messages.add({'message': botResponse, 'isUserMessage': false});
    });
  }
}