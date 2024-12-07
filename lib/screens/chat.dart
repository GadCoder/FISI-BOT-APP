import 'package:flutter/material.dart';
import 'messages.dart';
import 'package:chapa_tu_aula/services/api_chat.dart';
import 'dart:convert';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();

  // Lista de mensajes y si es userMessage[]
  List<Map<String, dynamic>> messages = [];

  // Lista de sugerencias
  final List<String> suggestions = [
    "¿Cuando termina el semestre?",
    "¿Noticias sobre la facultad?",
    "Horarios de atención"
  ];

  @override
  void initState() {
    super.initState();
    // Primer Mesaje de Saludo
    sendWelcomeMessage();
  }

  void sendWelcomeMessage() {
    setState(() {
      messages.add({
        'message': '''
Bienvenido! Soy FISI-CHATBOT. Aquí hay algunas cosas con las que puedo ayudarte:

- Consultar sobre trámites facultad.
- Información sobre profesores.
- Información sobre procesos/actividades que se llevan en la facultad.
- Otros servicios relacionados con la facultad.

''',
        'isUserMessage': false,
        'image': 'assets/images/chatbot.webp',
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
          // Sugerencias con fondo igual al chat
          if (suggestions.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              color: Theme.of(context).scaffoldBackgroundColor, // Match chat background
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.start,
                children: suggestions.map((suggestion) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      sendMessage(suggestion);
                    },
                    child: Text(suggestion),
                  );
                }).toList(),
              ),
            ),
          // Input para escribir mensajes
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
  void sendMessage(String text) async {
    if (text.isEmpty) return; // Don't send empty messages

    // Display the user's message immediately
    setState(() {
      messages.add({'message': text, 'isUserMessage': true});
    });

    try {
      // Add a "writing" message until the response is received
      setState(() {
        messages.add({'message': 'Escribiendo...', 'isUserMessage': false});
      });

      // Call the chatbot API
      final botAPI = ChatbotAPI(); // Assuming you're initializing your API instance here
      final response = await botAPI.queryChatbot(text);

      // Print response for debugging
      print('Bot Response: $response');

      // Handle possible null or invalid response
      setState(() {
        messages.removeLast(); // Remove the "Escribiendo..." message

        // Check if the response contains the 'answer' key
        if (response != null && response.containsKey('response') && response['response'] != null) {
          var answer = response['response']['answer'];

          // If the answer is a String, we can decode it
          if (answer is String) {
            // Decode the response to fix encoding issues (like Ã¡ -> á)
            answer = utf8.decode(latin1.encode(answer)); // Fix encoding issues
          } else if (answer is Map) {
            // If the answer is a Map, you might need to convert it to a string or handle it differently
            answer = jsonEncode(answer);
          } else {
            answer = 'No pude obtener una respuesta válida.';
          }

          // Add the final decoded answer to the messages
          messages.add({'message': answer, 'isUserMessage': false});
        } else {
          // Handle cases where 'response' key is missing or invalid
          messages.add({'message': 'No pude obtener una respuesta. Intenta de nuevo.', 'isUserMessage': false});
        }
      });
    } catch (e) {
      // Handle errors like network failure, API issues, etc.
      setState(() {
        messages.removeLast(); // Remove the "Escribiendo..." message
        messages.add({'message': 'Error al comunicarse con el bot: $e', 'isUserMessage': false});
      });
    }
  }
}
