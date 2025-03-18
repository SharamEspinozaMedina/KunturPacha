import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kuntur_pacha/screens/login_screen.dart';

class RestablecerContrasenaScreen extends StatefulWidget {
  final Function(String)
  onLoginSuccess; // Aceptar onLoginSuccess como parámetro

  RestablecerContrasenaScreen({required this.onLoginSuccess});
  @override
  _RestablecerContrasenaScreenState createState() =>
      _RestablecerContrasenaScreenState();
}

class _RestablecerContrasenaScreenState
    extends State<RestablecerContrasenaScreen> {
  bool _obscureText = true;
  final TextEditingController nuevaContrasenaController =
      TextEditingController();
  final TextEditingController codigoController =
      TextEditingController(); // Controlador para el código

  Future<void> _restablecerContrasena() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/restablecer-contrasenia/');
    final body = jsonEncode({
      'codigo':
          codigoController.text, // Usar el código ingresado por el usuario
      'nueva_contrasena': nuevaContrasenaController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Mostrar mensaje de éxito y regresar al login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña restablecida con éxito')),
        );
        // Redirigir a la pantalla de inicio de sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => LoginScreen(
                  onLoginSuccess: widget.onLoginSuccess, // Pasar onLoginSuccess
                ),
          ),
        );
        //Navigator.pop(context);  Regresar a la pantalla anterior
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
      backgroundColor: Colors.grey[200], // Fondo gris claro
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
                'Restablecer Contraseña',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),

              // Campo para el código de recuperación
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Código de Recuperación:',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: codigoController, // Controlador para el código
                decoration: InputDecoration(
                  hintText: 'Ingresa el código de recuperación',
                  prefixIcon: Icon(Icons.code),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 15),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nueva Contraseña:',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: nuevaContrasenaController, // Asigna el controlador
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Introduce tu nueva contraseña',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Color del botón
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
                onPressed: _restablecerContrasena, // Llama al método
                child: Text(
                  'Restablecer Contraseña',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navegar al inicio de sesión
                  Navigator.pop(context);
                },
                child: Text('Volver al inicio de sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
