import 'package:flutter/material.dart';
import 'package:kuntur_pacha/widgets/custom_appbar.dart';
import 'package:kuntur_pacha/screens/evento_screen.dart';
import 'package:kuntur_pacha/widgets/n8n_chat_widget.dart'; // Importa el nuevo widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Página Principal',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: PaginaPrincipal(usuario: null),
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  final String? usuario;

  const PaginaPrincipal({Key? key, this.usuario}) : super(key: key);

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  String? _usuario;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _usuario = widget.usuario;
  }

  void _iniciarSesion(String usuario) {
    setState(() {
      _usuario = usuario;
    });
  }

  void _cerrarSesion() {
    setState(() {
      _usuario = null;
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = 0;
      });
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => EventosScreen(
                usuario: _usuario,
                onLoginSuccess: _iniciarSesion,
                onLogout: _cerrarSesion,
                onTabSelected: _onItemTapped,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        usuario: _usuario,
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
        onLoginSuccess: _iniciarSesion,
        onLogout: _cerrarSesion,
        context: context,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Bienvenido a nuestra página web!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Nos alegra tenerte aquí. Explora nuestras últimas novedades y disfruta de la experiencia.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Novedades',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '© 2025 Bicentenario de Bolivia. Todos los derechos reservados.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => N8nChatWidget()),
          );
        },
        tooltip: 'Abrir Chat',
        child: Icon(Icons.chat),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
