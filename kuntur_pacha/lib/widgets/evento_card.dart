import 'package:flutter/material.dart';
import 'package:kuntur_pacha/screens/info_evento.dart';

class EventoCard extends StatelessWidget {
  final dynamic evento;

  EventoCard({required this.evento});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoEventoScreen(idEvento: evento['id']),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                evento['nombre'] ?? 'Sin nombre',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(evento['descripcion'] ?? 'Sin descripción'),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16),
                  SizedBox(width: 4),
                  Text(evento['fecha'] ?? 'Sin fecha'),
                  SizedBox(width: 16),
                  Icon(Icons.location_on, size: 16),
                  SizedBox(width: 4),
                  Text(evento['ubicacion'] ?? 'Sin ubicación'),
                ],
              ),
              if (evento['es_virtual'] == true)
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.videocam, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        'Evento Virtual',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
