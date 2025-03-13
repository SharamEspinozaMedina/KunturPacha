import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  //instanciacion de los datos
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController captchaController = TextEditingController();
  String? _genero;
  String? _pais;
  String? _ciudad;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final List<String> paises = ['Bolivia', 'Argentina', 'Chile', 'Perú'];
  final Map<String, List<String>> ciudades = {
    'Bolivia': ['La Paz', 'Cochabamba', 'Santa Cruz'],
    'Argentina': ['Buenos Aires', 'Córdoba', 'Rosario'],
    'Chile': ['Santiago', 'Valparaíso', 'Concepción'],
    'Perú': ['Lima', 'Cusco', 'Arequipa'],
  };
  String _captchaCode = ''; //a
  final TextEditingController codigoController = TextEditingController();
  String _codigoGenerado = '';
  bool _codigoEnviado = false;
  //verifiacacion: correo
  Future<void> _enviarCodigoEmail(String email) async {
    if (!_validarEmail(email)) {
      _mostrarMensaje('Por favor, ingresa un correo electrónico válido.');
      return;
    }

    final codigo = _generarCodigoVerificacion();

    try {
      await _enviarCodigoAlServidor(email, codigo);

      setState(() {
        _codigoGenerado = codigo;
        _codigoEnviado = true;
      });
      _mostrarMensaje('Código enviado a $email');
    } catch (e) {
      _mostrarMensaje('Error al enviar el correo: $e');
      print('Error al enviar el correo: $e');
    }
  }

  Future<void> _enviarCodigoAlServidor(String email, String codigo) async {
    final url = Uri.parse('http://127.0.0.1:5000/send_email');
    print('aca toy');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'email': email, 'codigo': codigo}),
    );
    print('yo me fui');
    if (response.statusCode != 200) {
      throw Exception('Error al enviar el correo: ${response.body}');
    }
  }

  // Función para validar el formato del correo electrónico
  bool _validarEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
    );
    return emailRegExp.hasMatch(email);
  }

  // Generar codigo
  String _generarCodigoVerificacion() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // verificamos codigo
  void _verificarCodigo() {
    if (codigoController.text == _codigoGenerado) {
      _mostrarMensaje('Correo verificado correctamente.');
    } else {
      _mostrarMensaje('Código incorrecto.');
    }
  }

  //funciones para el captcha
  @override
  void initState() {
    super.initState();
    _generarCaptcha();
  }

  void _generarCaptcha() {
    const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    setState(() {
      _captchaCode = String.fromCharCodes(
        List.generate(
          5,
          (index) => caracteres.codeUnitAt(random.nextInt(caracteres.length)),
        ),
      );
    });
  }

  //funcion para la contraseña
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _registrarse() async {
    // Validación: Las contraseñas deben coincidir.
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Las contraseñas no coinciden')));
      return;
    }

    // Validación de contraseña
    String password = passwordController.text;

    RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$',
    );

    if (!passwordRegExp.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'La contraseña debe contener al menos una letra, un número y un carácter especial',
          ),
        ),
      );
      return;
    }

    // Validación: cadenas mayores o igual a 8 caracteres
    if (passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La contraseña debe tener al menos 8 caracteres'),
        ),
      );
      return;
    }

    //validacion: captcha
    if (captchaController.text != _captchaCode) {
      _mostrarMensaje('Código CAPTCHA incorrecto.');
      print(
        'Código CAPTCHA incorrecto.${_captchaCode}  ${captchaController.text}',
      );
      _generarCaptcha();
      return;
    }

    // Construir la URL del endpoint de tu API.
    final url = Uri.parse('http://127.0.0.1:8000/api/usuarios/');

    // Crear el cuerpo (body) de la solicitud en formato JSON.
    final body = jsonEncode({
      "nombre": usuarioController.text,
      "correo": emailController.text,
      "contrasenia": passwordController.text,
      "genero": _genero ?? "",
      "pais": _pais ?? "",
      "ciudad": _ciudad ?? "",
    });
    try {
      // Enviar la solicitud POST a la API.
      final respuesta = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (respuesta.statusCode == 201) {
        // 201 significa que se creó correctamente.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado correctamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharam: ${respuesta.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la conexión sharam: $error')),
      );
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ESPINOZA MEDINA SHARAM')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Registro de Usuario',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: usuarioController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _enviarCodigoEmail(emailController.text),
                  child: Text('Enviar Código de Verificación'),
                ),
                if (_codigoEnviado) ...[
                  SizedBox(height: 20),
                  TextField(
                    controller: codigoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Código de Verificación',
                      prefixIcon: Icon(Icons.verified),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _verificarCodigo,
                    child: Text('Verificar Código'),
                  ),
                ],
                TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _toggleConfirmPasswordVisibility,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _genero,
                  decoration: InputDecoration(
                    labelText: 'Género',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['Masculino', 'Femenino', 'Otro']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _genero = value),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _pais,
                  decoration: InputDecoration(
                    labelText: 'País',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      paises
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() {
                        _pais = value;
                        _ciudad = null;
                      }),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _ciudad,
                  decoration: InputDecoration(
                    labelText: 'Ciudad',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      (_pais != null && ciudades.containsKey(_pais))
                          ? ciudades[_pais]!
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList()
                          : [],
                  onChanged: (value) => setState(() => _ciudad = value),
                ),
                SizedBox(height: 20),

                // CAPTCHA G
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    _captchaCode,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: captchaController,
                  decoration: InputDecoration(
                    labelText: 'Ingrese el CAPTCHA',
                    prefixIcon: Icon(Icons.security),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: _generarCaptcha,
                  child: Text('Generar nuevo CAPTCHA'),
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _registrarse,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Registrarse'),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navegar a la pantalla de inicio de sesión
                    },
                    child: Text('¿Ya tienes cuenta? ¡Inicia sesión aquí!'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
