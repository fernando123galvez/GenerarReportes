// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ReporteModel reporteModelFromJson(String str) =>
    ReporteModel.fromJson(json.decode(str));

String reporteModelToJson(ReporteModel data) => json.encode(data.toJson());

class ReporteModel {
  String id;
  String titulo;
  double valor;
  bool disponible;
  String fotoUrl;

  ReporteModel({
    this.id,
    this.titulo = '',
    this.valor = 0.0,
    this.disponible = true,
    this.fotoUrl,
  });

  factory ReporteModel.fromJson(Map<String, dynamic> json) => new ReporteModel(
        id: json["id"],
        titulo: json["titulo"],
        valor: json["valor"],
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
      );

  Map<String, dynamic> toJson() => {
        // "id"         : id,
        "titulo": titulo,
        "valor": valor,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
      };
}
