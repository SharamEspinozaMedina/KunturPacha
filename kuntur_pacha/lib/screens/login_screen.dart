import 'package:flutter/material.dart';
import '../widgets/estilos.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _submitLogin(String username, String email, String password) {
    // Aquí manejarías la lógica de autenticación
    print('Usuario: $username, Email: $email, Contraseña: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AuthForm(isLogin: true, onSubmit: _submitLogin),
      ),
    );
  }
}
