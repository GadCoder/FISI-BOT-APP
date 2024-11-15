import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class SumAPI {
  static const String baseUrl = 'sumvirtual.unmsm.edu.pe';
  var logger = Logger();

  Future<dynamic> login(String email, String password) async {
    var url = Uri.https(baseUrl, 'sumapi/loguearse');
    var data = jsonEncode({'usuario': email, 'clave': password});

    Map<String, String> headers = {
      'accept': 'application/json',
      'Accept-Encoding': 'gzip',
      'authorization': 'AUTH TOKEN',
      'Connection': 'Keep-Alive',
      'Content-Type': 'application/json',
      'Host': 'sumvirtual.unmsm.edu.pe',
      'User-Agent': 'okhttp/4.9.2',
    };

    final response = await http.post(url, body: data, headers: headers);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final token = responseBody['data'];

      final cookies = response.headers['set-cookie'];
      logger.d("COOKIES:${cookies!}");
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
      Map<String, dynamic> responseData = responseBody['data'][0];
      // logger.d("Response data: ");
      // logger.d(responseData);

      return {'response': responseData, 'cookies': cookieDict};
    } else {
      return null;
    }
  }

  Future<dynamic> getPersonalInfo(
      String accessToken, Map<String, String> cookies) async {
    var url = Uri.https(
        baseUrl, 'sumapi/alumno/mostrarInformacionPersonalFormulario');
    String bearerToken = 'Bearer $accessToken';

    Map<String, String> headers = {
      'accept': 'application/json, text/plain, */*',
      'Accept-Encoding': 'gzip',
      'authorization': bearerToken,
      'Connection': 'Keep-Alive',
      'Host': 'sumvirtual.unmsm.edu.pe',
      'User-Agent': 'okhttp/4.9.2',
    };
    String cookieHeader = cookies.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('; ');

    // Add the 'Cookie' header
    headers['cookie'] = cookieHeader;
    final response = await http.get(url, headers: headers);
    logger.d("HEADERS:");
    logger.d(headers);
    logger.d("STATUS CODE:${response.statusCode}");
    if (response.statusCode == 200) {
      logger.d("DATA RECIEVED");
      logger.d(response.body);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}
