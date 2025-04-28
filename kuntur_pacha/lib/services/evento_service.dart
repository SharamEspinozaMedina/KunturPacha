import 'dart:convert';
import 'package:http/http.dart' as http;

class EventoService {
  static const String baseUrl = 'http://tu-backend-django.com/api';

  static Future<List<dynamic>> obtenerEventos() async {
    final response = await http.get(Uri.parse('$baseUrl/eventos/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar eventos');
    }
  }

  static Future<List<dynamic>> filtrarEventos(
    Map<String, dynamic> filtros,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/eventos/filtrar/'),
      body: json.encode(filtros),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al filtrar eventos');
    }
  }
}
