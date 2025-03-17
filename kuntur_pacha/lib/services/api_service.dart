import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "http://127.0.0.1:8000/api/usuarios/";

  // Enviar datos a la API (POST)
  Future<void> enviarDatos(
    String nombre,
    String correo,
    String contrasenia,
    String genero,
    String pais,
    String ciudad,
  ) async {
    final respuesta = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre": nombre,
        "correo": correo,
        "contrasenia": contrasenia,
        "genero": genero,
        "pais": pais,
        "ciudad": ciudad,
      }),
    );

    if (respuesta.statusCode == 201) {
      print("✅ Usuario creado correctamente");
    } else {
      print("❌ Error al crear usuario: ${respuesta.body}");
    }
  }
}
