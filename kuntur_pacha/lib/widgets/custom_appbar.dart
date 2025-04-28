import 'package:flutter/material.dart';
import 'package:kuntur_pacha/screens/login_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? usuario;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final Function(String) onLoginSuccess;
  final Function() onLogout;
  final BuildContext context;

  const CustomAppBar({
    Key? key,
    required this.usuario,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onLoginSuccess,
    required this.onLogout,
    required this.context,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildTab(String text, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () => onTabSelected(index),
        child: Text(
          text,
          style: TextStyle(
            color: selectedIndex == index ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(
            usuario != null ? 'Bienvenido, $usuario!' : 'Bienvenido',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          _buildTab('INICIO', 0),
          _buildTab('EVENTO', 1),
          _buildTab('AGENDA', 2),
          _buildTab('CRUD', 3),
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
        if (usuario != null)
          PopupMenuButton<String>(
            offset: Offset(0, 50),
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                usuario![0].toUpperCase(),
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
                onLogout();
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
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => LoginScreen(onLoginSuccess: onLoginSuccess),
                ),
              );
            },
            child: Text('Acceder', style: TextStyle(color: Colors.white)),
          ),
      ],
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
