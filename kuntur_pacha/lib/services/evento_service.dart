import 'dart:convert';
import 'package:http/http.dart' as http;

class EventoService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<List<dynamic>> obtenerEventos() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/eventos/'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 10)); // Timeout de 10 segundos

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes)); // Soporte UTF-8
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en obtenerEventos: $e');
      throw Exception('Error al conectar con el servidor');
    }
  }

  static Future<List<dynamic>> filtrarEventos(
    Map<String, dynamic> filtros,
  ) async {
    // Limpia filtros (remueve 'Todos' y valores por defecto)
    final params = Map<String, String>.fromEntries(
      filtros.entries
          .where(
            (e) =>
                e.value != null &&
                e.value != 'Todos' &&
                e.value != 'Por Defecto',
          )
          .map((e) => MapEntry(e.key, e.value.toString())),
    );

    try {
      final uri = Uri.parse(
        '$baseUrl/eventos/filtrar/',
      ).replace(queryParameters: params);

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en filtrarEventos: $e');
      throw Exception('Error al filtrar eventos');
    }
  }
}
