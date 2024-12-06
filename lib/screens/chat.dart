import 'package:flutter/material.dart';
import 'messages.dart';
import 'package:chapa_tu_aula/services/api_chat.dart';

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
    if (text.isEmpty) return; // No enviar mensajes vacíos

    // Add the user's message immediately
    setState(() {
      messages.add({'message': text, 'isUserMessage': true});
    });

    try {
      // Show a loading indicator or placeholder while waiting for the bot's response
      setState(() {
        messages.add({'message': 'Escribiendo...', 'isUserMessage': false});
      });

      // Call the chatbot API
      final botAPI = ChatbotAPI(); // Replace with your secret key
      final response = await botAPI.queryChatbot(text);

      // Remove the "Escribiendo..." message and replace it with the bot's response
      setState(() {
        messages.removeLast(); // Remove the placeholder
        if (response != null && response['answer'] != null) {
          messages.add({'message': response['answer'], 'isUserMessage': false});
        } else {
          messages.add({'message': 'Hubo un problema al obtener la respuesta.', 'isUserMessage': false});
        }
      });
    } catch (e) {
      // Handle errors gracefully
      setState(() {
        messages.removeLast(); // Remove the placeholder
        messages.add({'message': 'Error al comunicarse con el bot.', 'isUserMessage': false});
      });
    }
  }
}
