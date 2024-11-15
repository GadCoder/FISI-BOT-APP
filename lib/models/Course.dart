import 'dart:convert';

class Course {
  final int ciclo;
  final String carrera;
  final String codigoCurso;
  final String plan;
  final String nombreCurso;
  final int id;
  final int creditaje;

  Course({
    required this.ciclo,
    required this.carrera,
    required this.codigoCurso,
    required this.plan,
    required this.nombreCurso,
    required this.id,
    required this.creditaje,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      ciclo: json['ciclo'],
      carrera: json['carrera'],
      codigoCurso: json['codigo_curso'],
      plan: json['plan'],
      nombreCurso: utf8.decode(json['nombre_curso'].runes.toList()),
      id: json['id'],
      creditaje: json['creditaje'],
    );
  }
}
