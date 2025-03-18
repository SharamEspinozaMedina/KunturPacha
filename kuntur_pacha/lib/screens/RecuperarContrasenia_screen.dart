import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kuntur_pacha/screens/RestablecerContrasenia_screen.dart';

class RecuperarContrasenaScreen extends StatefulWidget {
  final Function(String)
  onLoginSuccess; // Aceptar onLoginSuccess como parámetro

  RecuperarContrasenaScreen({required this.onLoginSuccess});

  @override
  _RecuperarContrasenaScreenState createState() =>
      _RecuperarContrasenaScreenState();
}

class _RecuperarContrasenaScreenState extends State<RecuperarContrasenaScreen> {
  final TextEditingController correoController = TextEditingController();

  Future<void> _enviarCorreo() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/recuperar-contrasenia/');
    final body = jsonEncode({'correo': correoController.text});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Navegar a la pantalla de restablecimiento
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => RestablecerContrasenaScreen(
                  onLoginSuccess:
                      widget.onLoginSuccess, // Usar widget.onLoginSuccess
                ),
          ),
        );
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Color de fondo similar a la imagen
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Recuperar Contraseña',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ingresa tu correo electrónico:',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: correoController, // Asigna el controlador
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700], // Color del botón
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
                onPressed: _enviarCorreo, // Llama al método _enviarCorreo
                child: Text('ENVIAR', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
