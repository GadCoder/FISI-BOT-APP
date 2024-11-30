import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ChatbotAPI {
  static const String baseUrl = 'gpt-api-tas.gadsw.dev';
  var logger = Logger();

  // Base headers
  Map<String, String> get baseHeaders => {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        
      };

  Future<dynamic> queryChatbot(String prompt, {bool fromContext = false}) async {
    var url = Uri.https(baseUrl, '/openai/query', {
      'secret_key': 'gta5elmejor',
      'from_context': fromContext.toString()
    });
    var data = jsonEncode({'prompt': prompt});

    // Copy base headers and add authorization token
    Map<String, String> headers = Map<String, String>.from(baseHeaders);
    headers['authorization'] = 'AUTH TOKEN';

    logger.i('Sending POST request to $url');
    logger.i('Request headers: $headers');
    logger.i('Request body: $data');

    try {
      final response = await http.post(url, body: data, headers: headers);

      logger.i('Response status code: ${response.statusCode}');
      logger.i('Response headers: ${response.headers}');
      logger.i('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final cookies = response.headers['set-cookie'];

        if (cookies != null) {
          logger.d("Cookies: $cookies");
        } else {
          logger.d("No cookies found in the response.");
        }

        final cookieDict = <String, String>{};

        if (cookies != null) {
          final cookieList = cookies.split(', ');
          for (var cookie in cookieList) {
            final cookieParts = cookie.split('; ')[0].split('=');
            if (cookieParts.length == 2) {
              cookieDict[cookieParts[0]] = cookieParts[1];
            }
          }
        }

        logger.d("Response data: $responseBody");
        return {'response': responseBody, 'cookies': cookieDict};
      } else if (response.statusCode == 422) {
        logger.e("Validation Error: ${response.body}");
        return {'error': 'Validation Error', 'body': response.body};
      } else {
        logger.e("HTTP error: ${response.statusCode} - ${response.reasonPhrase}");
        return {'error': 'Failed with status code ${response.statusCode}', 'body': response.body};
      }
    } catch (e) {
      logger.e("Exception: $e");
      return {'error': 'Exception occurred', 'details': e.toString()};
    }
  }
}
