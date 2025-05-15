import 'package:flutter/material.dart';
import 'package:kuntur_pacha/services/evento_service.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoEventoScreen extends StatefulWidget {
  final int idEvento;

  const InfoEventoScreen({Key? key, required this.idEvento}) : super(key: key);

  @override
  _InfoEventoScreenState createState() => _InfoEventoScreenState();
}

class _InfoEventoScreenState extends State<InfoEventoScreen> {
  // ignore: unused_field
  late Future<Map<String, dynamic>> _eventoFuture;
  bool _isLoading = true;
  Map<String, dynamic>? _eventoData;

  @override
  void initState() {
    super.initState();
    _eventoFuture = _cargarDetallesEvento();
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo abrir el enlace')));
    }
  }

  Future<Map<String, dynamic>> _cargarDetallesEvento() async {
    try {
      final data = await EventoService.obtenerDetallesEvento(widget.idEvento);
      setState(() {
        _eventoData = data;
        _isLoading = false;
      });
      return data;
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar detalles: $e')));
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLoading ? 'Cargando...' : _eventoData?['nombre'] ?? 'Evento',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildEventoDetails(),
    );
  }

  Widget _buildEventoDetails() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con fecha y ubicación
          _buildHeaderSection(),
          SizedBox(height: 20),

          // Modalidad (Presencial/Virtual/Híbrido)
          _buildModalidadSection(),

          // Enlaces si es virtual o híbrido
          if (_eventoData?['es_virtual'] == true ||
              _eventoData?['es_hibrido'] == true)
            _buildEnlacesSection(),

          // Descripción
          _buildSectionTitle('Descripción'),
          Text(
            _eventoData?['descripcion'] ?? 'No hay descripción disponible',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),

          // Participantes/Expositores
          if (_eventoData?['participantes'] != null &&
              (_eventoData?['participantes'] as List).isNotEmpty)
            _buildParticipantesSection(),

          // Cronograma
          if (_eventoData?['cronograma'] != null &&
              (_eventoData?['cronograma'] as List).isNotEmpty)
            _buildCronogramaSection(),

          // Patrocinadores
          if (_eventoData?['patrocinadores'] != null &&
              (_eventoData?['patrocinadores'] as List).isNotEmpty)
            _buildPatrocinadoresSection(),

          // Recursos
          if (_eventoData?['recursos'] != null &&
              (_eventoData?['recursos'] as List).isNotEmpty)
            _buildRecursosSection(),

          // Organizador
          if (_eventoData?['organizador'] != null) _buildOrganizadorSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _eventoData?['fecha'] ?? 'Fecha no especificada',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.location_on, size: 16),
            SizedBox(width: 4),
            Text(_eventoData?['ubicacion'] ?? 'Ubicación no especificada'),
          ],
        ),
      ],
    );
  }

  Widget _buildModalidadSection() {
    final esPresencial = _eventoData?['es_presencial'] ?? false;
    final esVirtual = _eventoData?['es_virtual'] ?? false;

    String modalidad = 'Presencial';
    if (esPresencial && esVirtual) {
      modalidad = 'Híbrido (Presencial y Virtual)';
    } else if (esVirtual) {
      modalidad = 'Virtual';
    }

    return Row(
      children: [
        Icon(Icons.calendar_view_day, color: Colors.blue),
        SizedBox(width: 8),
        Text(
          'Modalidad: $modalidad',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEnlacesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Enlaces del Evento'),
        ...(_eventoData?['multimedia'] as List? ?? []).map<Widget>((enlace) {
          return ListTile(
            leading: Icon(Icons.link),
            title: Text(enlace['descripcion'] ?? 'Enlace'),
            subtitle: Text(enlace['url_archivo'] ?? ''),
            // Aquí podrías abrir el enlace en un navegador
            // launch(enlace['url']);
            onTap: () => _launchUrl(enlace['url_archivo']),
          );
        }).toList(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildParticipantesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Participantes'),
        Column(
          children:
              (_eventoData?['participantes'] as List).map<Widget>((
                participante,
              ) {
                return ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(participante['nombre'] ?? ''),
                  subtitle: Text(participante['tipo'] ?? ''),
                  trailing: Text(participante['descripcion'] ?? ''),
                );
              }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCronogramaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Cronograma'),
        ...(_eventoData?['cronograma'] as List).map<Widget>((item) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item['hora_inicio']} - ${item['hora_fin']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item['actividad'] ?? 'Actividad',
                    style: TextStyle(fontSize: 16),
                  ),
                  if (item['descripcion'] != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(item['descripcion']),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPatrocinadoresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Patrocinadores'),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children:
              (_eventoData?['patrocinadores'] as List).map<Widget>((
                patrocinador,
              ) {
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.business, size: 40),
                        Text(patrocinador['nombre'] ?? ''),
                        if (patrocinador['tipo_apoyo'] != null)
                          Text(
                            patrocinador['tipo_apoyo'],
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRecursosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Recursos'),
        DataTable(
          columns: [
            DataColumn(label: Text('Recurso')),
            DataColumn(label: Text('Cantidad')),
            DataColumn(label: Text('Disponibilidad')),
          ],
          rows:
              (_eventoData?['recursos'] as List).map<DataRow>((recurso) {
                return DataRow(
                  cells: [
                    DataCell(Text(recurso['nombre'] ?? '')),
                    DataCell(Text(recurso['cantidad'].toString())),
                    DataCell(
                      Text(recurso['disponibilidad'] ?? ''),
                      showEditIcon: recurso['disponibilidad'] != 'Disponible',
                    ),
                  ],
                );
              }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildOrganizadorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Organizador'),
        ListTile(
          leading: Icon(Icons.group),
          title: Text(_eventoData?['organizador']?['nombre'] ?? 'Organizador'),
          subtitle: Text(_eventoData?['organizador']?['contacto'] ?? ''),
          onTap: () {
            // Podrías abrir el correo o contacto del organizador
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
