import 'dart:convert';

class Section {
  final String dia;
  final int horaInicio;
  final int horaFin;

  Section({required this.dia, required this.horaInicio, required this.horaFin});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
        dia: json['dia'],
        horaInicio: json['hora_inicio'],
        horaFin: json['hora_fin']);
  }
}
