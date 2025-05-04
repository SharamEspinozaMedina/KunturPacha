import 'package:flutter/material.dart';

class FiltrosEventos extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltrar;

  FiltrosEventos({required this.onFiltrar});

  @override
  _FiltrosEventosState createState() => _FiltrosEventosState();
}

class _FiltrosEventosState extends State<FiltrosEventos> {
  String generoSeleccionado = 'Todos';
  String anioSeleccionado = 'Todos';
  String tipoSeleccionado = 'Todos';
  String estadoSeleccionado = 'Todos';
  String ordenSeleccionado = 'Por Defecto';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDropdown(
                'Género',
                ['Todos', 'Cultural', 'Deportivo', 'Académico', 'Gastronómico'],
                generoSeleccionado,
                (value) {
                  setState(() => generoSeleccionado = value!);
                  _aplicarFiltros();
                },
              ),
              _buildDropdown(
                'Año',
                ['Todos', '2023', '2024'],
                anioSeleccionado,
                (value) {
                  setState(() => anioSeleccionado = value!);
                  _aplicarFiltros();
                },
              ),
              _buildDropdown(
                'Tipo',
                ['Todos', 'Presencial', 'Virtual'],
                tipoSeleccionado,
                (value) {
                  setState(() => tipoSeleccionado = value!);
                  _aplicarFiltros();
                },
              ),
              _buildDropdown(
                'Estado',
                ['Todos', 'Activo', 'Finalizado'],
                estadoSeleccionado,
                (value) {
                  setState(() => estadoSeleccionado = value!);
                  _aplicarFiltros();
                },
              ),
              _buildDropdown(
                'Orden',
                ['Por Defecto', 'Recientes', 'A-Z', 'Calificación'],
                ordenSeleccionado,
                (value) {
                  setState(() => ordenSeleccionado = value!);
                  _aplicarFiltros();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:'),
        DropdownButton<String>(
          value: value,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _aplicarFiltros() {
    final Map<String, dynamic> filtros = {};

    if (generoSeleccionado != 'Todos') {
      filtros['tipo'] = generoSeleccionado;
    }

    if (anioSeleccionado != 'Todos') {
      filtros['año'] = anioSeleccionado;
    }

    if (tipoSeleccionado != 'Todos') {
      filtros['modalidad'] = tipoSeleccionado; // Cambiado a 'modalidad'
    }

    if (estadoSeleccionado != 'Todos') {
      filtros['estado'] =
          estadoSeleccionado.toLowerCase(); // 'activo' o 'finalizado'
    }

    if (ordenSeleccionado != 'Por Defecto') {
      filtros['orden'] =
          ordenSeleccionado == 'Recientes'
              ? '-fecha'
              : ordenSeleccionado == 'A-Z'
              ? 'nombre'
              : 'calificacion';
    }

    widget.onFiltrar(filtros);
  }
}
