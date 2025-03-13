import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final void Function(String username, String email, String password) onSubmit;

  const AuthForm({super.key, required this.isLogin, required this.onSubmit});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';

  void _trySubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_username, _email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!widget.isLogin)
            TextFormField(
              key: ValueKey('username'),
              decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
              onSaved: (value) => _username = value!,
              validator:
                  (value) =>
                      value!.isEmpty ? 'Ingrese un nombre de usuario' : null,
            ),
          TextFormField(
            key: ValueKey('email'),
            decoration: const InputDecoration(labelText: 'Correo Electrónico'),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _email = value!,
            validator:
                (value) => value!.isEmpty ? 'Ingrese un correo válido' : null,
          ),
          TextFormField(
            key: ValueKey('password'),
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            onSaved: (value) => _password = value!,
            validator:
                (value) =>
                    value!.length < 6
                        ? 'Debe tener al menos 6 caracteres'
                        : null,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _trySubmit,
            child: Text(widget.isLogin ? 'Iniciar Sesión' : 'Registrarse'),
          ),
        ],
      ),
    );
  }
}
