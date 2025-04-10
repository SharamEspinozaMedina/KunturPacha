import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kuntur_pacha/main.dart';
import 'package:kuntur_pacha/screens/RecuperarContrasenia_screen.dart';
import 'package:kuntur_pacha/screens/registro_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  final Function(String)
  onLoginSuccess; // Función para manejar el éxito del login

  LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _mensajeFlash;

  Future<void> _iniciarSesion() async {
    String correo = usuarioController.text;
    String contrasena = contrasenaController.text;

    if (correo.isEmpty || contrasena.isEmpty) {
      setState(() {
        _mensajeFlash = "Por favor, ingresa usuario y contraseña.";
      });
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/api/login/');
    final body = jsonEncode({'correo': correo, 'contrasena': contrasena});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Inicio de sesión exitoso
        final data = jsonDecode(response.body);
        setState(() {
          _mensajeFlash = "Inicio de sesión exitoso: ${data['usuario']}";
        });

        // Llamar a la función onLoginSuccess con el nombre del usuario
        widget.onLoginSuccess(data['usuario']);

        // Navegar a la pantalla principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => PaginaPrincipal(
                  usuario: data['usuario'],
                ), // Reemplaza "MainScreen" con el nombre de tu pantalla principal
          ),
        );
        // Contraseña incorrecta
        setState(() {
          _mensajeFlash = "Contraseña incorrecta.";
        });
      } else if (response.statusCode == 404) {
        // Usuario no encontrado
        setState(() {
          _mensajeFlash = "Usuario no encontrado.";
        });
      } else {
        // Otro error
        setState(() {
          _mensajeFlash = "Error en el servidor.";
        });
      }
    } catch (e) {
      // Error de conexión
      setState(() {
        _mensajeFlash = "Error de conexión: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF), // Fondo gris claro
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              width: 400, // Ancho fijo
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Iniciar Sesión",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),

                  // Mensaje Flash (Éxito/Error)
                  if (_mensajeFlash != null)
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.black54),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _mensajeFlash!,
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Campo Usuario
                  TextField(
                    controller: usuarioController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      labelText: "Correo Electrónico",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Campo Contraseña
                  TextField(
                    controller: contrasenaController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      labelText: "Contraseña",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Botón de Iniciar Sesión
                  ElevatedButton(
                    onPressed: _iniciarSesion,
                    child: Text("INICIAR SESIÓN"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Enlace de Recuperar Contraseña
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RecuperarContrasenaScreen(
                                onLoginSuccess: widget.onLoginSuccess,
                              ),
                        ),
                      );
                    },
                    child: Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),

                  // Enlace para Registrarse
                  Builder(
                    builder:
                        (context) => Text.rich(
                          TextSpan(
                            text: "¿No tienes cuenta? ",
                            style: TextStyle(color: Colors.black54),
                            children: [
                              TextSpan(
                                text: "¡Crea una ahora aquí!",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => RegistroScreen(),
                                          ),
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
