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
  int _selectedIndex = 0;

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

  //navegacion de pestanas
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Implementar navegación para cada pestaña
  }

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
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              // Mensaje "Bienvenido" a la izquierda
              Text(
                _usuario != null ? 'Bienvenido, $_usuario!' : 'Bienvenido',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              // Pestañas INICIO, EVENTO, AGENDA, CRUD
              _buildTab('INICIO', 0),
              _buildTab('EVENTO', 1),
              _buildTab('AGENDA', 2),
              _buildTab('CRUD', 3),
              // Campo de búsqueda
              Container(
                width: 150,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'BUSCAR...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          actions: [
            // Botón de login o avatar
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
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenido de tu página
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

  Widget _buildTab(String text, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () => _onItemTapped(index),
        child: Text(
          text,
          style: TextStyle(
            color: _selectedIndex == index ? Colors.white : Colors.white70,
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

/*
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
*/
