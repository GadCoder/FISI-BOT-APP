import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class MessagesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
@override
Widget build(BuildContext context) {
  var w = MediaQuery.of(context).size.width;
  return ListView.separated(
    itemBuilder: (context, index) {
      // Extract message and optional image from the current message
      final currentMessage = widget.messages[index];
      final messageText = currentMessage['message'];
      final isUserMessage = currentMessage['isUserMessage'];
      final messageImage = currentMessage['image'];

      return Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: isUserMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: isUserMessage
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(isUserMessage ? 0 : 20),
                      topLeft: Radius.circular(isUserMessage ? 20 : 0),
                    ),
                    color: isUserMessage
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                  ),
                  constraints: BoxConstraints(maxWidth: w * 2 / 3),
                  child: _buildMessageContent(
                    messageText,
                    isUserMessage,
                    image: messageImage, // Pasar la imagen dinamicamente
                  ),
                ),
              ],
            ),
            // Botones: Reportar, Copiar y Compartir (Solo para mensajes del bot).
            if (!isUserMessage && index > 0)
              Row(
                mainAxisAlignment: isUserMessage
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.report),
                    onPressed: () {
                      reportMessage(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      copyMessage(messageText);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      shareMessage(messageText);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.replay),
                    onPressed: () {
                      reloadMessage(messageText);
                    },
                  ),
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


Widget _buildMessageContent(String message, bool isUserMessage, {String? image}) {
  final urlRegExp = RegExp(
    r'(https?://[^\s]+)',
    caseSensitive: false,
  );

  final matches = urlRegExp.allMatches(message);

  List<Widget> content = [];

  // Add text content
  if (matches.isEmpty) {
    content.add(
      Text(
        message,
        style: TextStyle(
          color: isUserMessage ? Colors.black : Colors.white,
        ),
      ),
    );
  } else {
    final List<TextSpan> spans = [];
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: message.substring(start, match.start),
          style: TextStyle(
            color: isUserMessage ? Colors.black : Colors.white,
          ),
        ));
      }

      final url = message.substring(match.start, match.end);
      spans.add(
        TextSpan(
          text: url,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _launchUrl(url),
        ),
      );

      start = match.end;
    }

    if (start < message.length) {
      spans.add(TextSpan(
        text: message.substring(start),
        style: TextStyle(
          color: isUserMessage ? Colors.black : Colors.white,
        ),
      ));
    }

    content.add(
      RichText(
        text: TextSpan(children: spans),
      ),
    );
  }

// Agregar Imagen (Opcional)
if (image != null) {
  content.add(
    SizedBox(height: 3), // Espacio
  );
  content.add(
    Center(
      child: Image.asset(
        image,
        height: 90,
        width: 100, // Ajustar Tamaño
        fit: BoxFit.contain, 
      ),
    ),
  );
}


  return Column(
    crossAxisAlignment:
        isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: content,
  );
}


  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo ingresar a: $url')),
      );
    }
  }

  void copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mensaje Copiado!')),
    );
  }

  void shareMessage(String message) {
    Share.share(message);
  }
  
  void reloadMessage(String message) {
    //falta definir
  }

  void reportMessage(int index) {
  showDialog(
    context: context,
    builder: (context) {
      String? selectedReason;
      TextEditingController textController = TextEditingController();
      return AlertDialog(
        title: Text('Reportar Respuesta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              hint: Text('Elija una razón'),
              value: selectedReason,
              items: [
                DropdownMenuItem(value: 'Inadecuado', child: Text('Inadecuado')),
                DropdownMenuItem(value: 'Impreciso', child: Text('Impreciso')),
                DropdownMenuItem(value: 'Otro', child: Text('Otro')),
              ],
              onChanged: (value) {
                selectedReason = value;
              },
            ),
            TextField(
              controller: textController,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Especifique más (máx. 500 caracteres)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // You might want to handle the collected data here
              String? reason = selectedReason;
              String comments = textController.text;
              // Handle the data as needed

              Navigator.of(context).pop();
            },
            child: Text('Reportar'),
          ),
        ],
      );
    },
  );
}

}
