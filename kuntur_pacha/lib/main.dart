import 'package:flutter/material.dart';
import 'screens/registro_screen.dart'; // Importamos la pantalla de registro

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Usuario',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegistroScreen(), // Aquí llamamos a la pantalla de registro
    );
  }
}
