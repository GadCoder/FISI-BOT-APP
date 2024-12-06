import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../components/shared/secure_storage.dart';

class SumAPI {
  var logger = Logger();
  final storage = SecureStorage().storage;

  static const String baseUrl = 'sumvirtual.unmsm.edu.pe';
  Map<String, String> baseHeaders = {
    'accept': 'application/json',
    'Accept-Encoding': 'gzip',
    'Connection': 'Keep-Alive',
    'Content-Type': 'application/json',
    'Host': 'sumvirtual.unmsm.edu.pe',
    'User-Agent': 'okhttp/4.9.2',
  };

  Future<dynamic> login(String email, String password) async {
    var url = Uri.https(baseUrl, 'sumapi/auth/login');
    var data = jsonEncode({'username': email, 'password': password});

    Map<String, String> loginHeaders = baseHeaders;
    loginHeaders["authorization"] = "AUTH TOKEN";

    final response = await http.post(url, body: data, headers: loginHeaders);
    if (response.statusCode != 200) {
      return false;
    }
    final responseBody = jsonDecode(response.body);
    final token = responseBody['token'];
    await storage.write(key: "auth-token", value: token);
    return true;

  }

  Future<dynamic> getPersonalInfo() async {
    var url = Uri.https(
        baseUrl, 'sumapi/alumno/info');
    String? authToken = await storage.read(
        key: "auth-token");

    if (authToken == null) return null;
    Map<String, String> requestHeaders = baseHeaders;
    requestHeaders["authorization"] = "Bearer $authToken";

    final response = await http.get(url, headers: requestHeaders);
    if (response.statusCode != 200) {
      logger.d("ERROR");
      logger.d(response.statusCode);
      return null;
    }
    logger.d("DATA RECIEVED");
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
