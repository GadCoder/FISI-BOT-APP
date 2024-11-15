import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/Course.dart';

class FISIHorariosAPI {
  static const String baseUrl = 'fisi-horarios.gadsw.dev';
  var logger = Logger();

  Future<List<Course>?> getCursosFromCarrera(
      String plan, String carrera) async {
    var endpointUrl = "cursos/get-cursos-from-carrera/$plan/$carrera";
    var url = Uri.https(baseUrl, endpointUrl);
    Map<String, String> headers = {
      'accept': 'application/json',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode != 200) {
      logger.d("No cursos founded for carrera $carrera on plan $plan");
      return null;
    }

    final responseBody = jsonDecode(response.body);
    // logger.d(responseBody);
    List<Course> courses =
        (responseBody as List).map((json) => Course.fromJson(json)).toList();
    return courses;
  }
}
