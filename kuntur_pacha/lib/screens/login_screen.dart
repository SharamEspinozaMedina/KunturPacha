import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kuntur_pacha/screens/registro_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _mensajeFlash;

  void _iniciarSesion() {
    String usuario = usuarioController.text;
    String contrasena = contrasenaController.text;

    if (usuario.isEmpty || contrasena.isEmpty) {
      setState(() {
        _mensajeFlash = "Por favor, ingresa usuario y contraseña.";
      });
      return;
    }

    print("Iniciando sesión con: $usuario - $contrasena");

    setState(() {
      _mensajeFlash = "Tu contraseña ha sido restablecida con éxito.";
    });
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
                      labelText: "Usuario",
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
                    onPressed: () {},
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
