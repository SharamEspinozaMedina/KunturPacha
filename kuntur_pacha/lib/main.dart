import 'package:flutter/material.dart';
import 'package:kuntur_pacha/screens/login_screen.dart';

void main() {
  runApp(PaginaPrincipal(usuario: null)); // Iniciar sin usuario
}

class PaginaPrincipal extends StatefulWidget {
  final String? usuario; // Parámetro opcional para el usuario

  // Constructor que acepta el parámetro "usuario"
  const PaginaPrincipal({Key? key, this.usuario}) : super(key: key);
  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  String? _usuario; // Estado del usuario (null si no está autenticado)

  @override
  void initState() {
    super.initState();
    // Inicializar el estado con el valor del constructor
    _usuario = widget.usuario;
  }

  // Método para simular el inicio de sesión
  void _iniciarSesion(String usuario) {
    setState(() {
      _usuario = usuario;
    });
  }

  // Método para cerrar sesión
  void _cerrarSesion() {
    setState(() {
      _usuario = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Página Principal',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[800],
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            _usuario != null ? 'Bienvenido, $_usuario!' : 'Bienvenido',
          ),
          actions: [
            if (_usuario != null)
              PopupMenuButton<String>(
                offset: Offset(0, 50),
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    _usuario![0].toUpperCase(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                onSelected: (value) {
                  if (value == 'perfil') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MiPerfilScreen()),
                    );
                  } else if (value == 'logout') {
                    _cerrarSesion();
                  }
                },
                itemBuilder:
                    (BuildContext context) => [
                      PopupMenuItem(
                        value: 'perfil',
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Mi Perfil'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'logout',
                        child: ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text('Cerrar sesión'),
                        ),
                      ),
                    ],
              )
            else
              Builder(
                builder:
                    (context) => TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    LoginScreen(onLoginSuccess: _iniciarSesion),
                          ),
                        );
                      },
                      child: Text(
                        'Acceder',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              ),
            /*
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => LoginScreen(
                            onLoginSuccess: _iniciarSesion,
                          ), // Pasar la función
                    ),
                  );
                },
                child: Text('Acceder', style: TextStyle(color: Colors.white)),
              ),
              */
          ],
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
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              '© 2025 Bicentenario de Bolivia. Todos los derechos reservados.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class MiPerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mi Perfil')),
      body: Center(child: Text('Aquí irá la información del perfil')),
    );
  }
}
