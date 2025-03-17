import 'package:flutter/material.dart';
import 'package:kuntur_pacha/screens/login_screen.dart';
//import 'screens/registro_screen.dart'; // Importamos la pantalla de registro

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Usuario',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(), // Aquí llamamos a la pantalla de registro
    );
  }
}
