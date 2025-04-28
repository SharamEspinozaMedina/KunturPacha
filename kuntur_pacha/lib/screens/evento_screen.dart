import 'package:flutter/material.dart';
import 'package:kuntur_pacha/services/evento_service.dart';
import 'package:kuntur_pacha/widgets/filtros_eventos.dart';
import 'package:kuntur_pacha/widgets/evento_card.dart';
import 'package:kuntur_pacha/widgets/custom_appbar.dart';
import 'package:kuntur_pacha/main.dart'; // Importa PaginaPrincipal

class EventosScreen extends StatefulWidget {
  final String? usuario;
  final Function(String) onLoginSuccess;
  final Function() onLogout;
  final Function(int) onTabSelected; // 🔵 Aquí ahora correctamente declarado

  const EventosScreen({
    Key? key,
    this.usuario,
    required this.onLoginSuccess,
    required this.onLogout,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  List<dynamic> eventos = [];
  bool isLoading = true;
  int _selectedIndex = 1; // Aquí estamos en EVENTO (índice 1)

  @override
  void initState() {
    super.initState();
    _cargarEventos();
  }

  Future<void> _cargarEventos() async {
    try {
      final data = await EventoService.obtenerEventos();
      setState(() {
        eventos = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error cargando eventos: $e');
    }
  }

  void _onTabSelected(int index) {
    if (index == 0) {
      // Ir a INICIO
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaginaPrincipal(usuario: widget.usuario),
        ),
      );
    } else if (index == 1) {
      // Estamos en EVENTO, no hacemos nada
    } else {
      // Para futuros tabs como AGENDA o CRUD
      widget.onTabSelected(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        usuario: widget.usuario,
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
        onLoginSuccess: widget.onLoginSuccess,
        onLogout: widget.onLogout,
        context: context,
      ),
      body: Column(
        children: [
          Text(
            '¡Eventos!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          FiltrosEventos(
            onFiltrar: (filtros) {
              // Lógica para filtrar eventos
              print('Filtros aplicados: $filtros');
            },
          ),
          Expanded(
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount: eventos.length,
                      itemBuilder: (context, index) {
                        return EventoCard(evento: eventos[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
