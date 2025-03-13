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

/*
class ApiService {
  static const String baseUrl =
      'http://127.0.0.1:8000/api/usuarios/"'; // Cambia esto por la URL de tu API

  static Future<bool> registerUser(
    String usuario,
    String email,
    String password,
    String genero,
    String pais,
    String ciudad,
  ) async {
    final url = Uri.parse(
      '$baseUrl/register',
    ); // Asegúrate de que la ruta sea correcta
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario": usuario,
        "email": email,
        "password": password,
        "genero": genero,
        "pais": pais,
        "ciudad": ciudad,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Registro exitoso
    } else {
      return false; // Error en el registro
    }
  }
}
*/

/*
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://192.168.0.4:8080"; // Cambia por la IP de tu PC

  // Registro de usuario
  static Future<Map<String, dynamic>> registrarUsuario({
    required String nombre,
    required String correo,
    required String contrasenia,
    required String genero,
    required String pais,
    required String ciudad,
  }) async {
    final url = Uri.parse('$baseUrl/registro');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre": nombre,
        "correo_electronico": correo,
        "contrasenia": contrasenia,
        "genero": genero,
        "pais": pais,
        "ciudad": ciudad,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al registrar usuario");
    }
  }
}
*/
