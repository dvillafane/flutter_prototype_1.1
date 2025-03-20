import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prototipo_1/home_screen.dart';
import 'package:flutter_prototipo_1/register_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  String _error = '';
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      _formKey.currentState!.save();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      if (userCredential.user?.emailVerified ?? false) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MyHomePage()),
          (route) => false,
        );
      } else {
        setState(() => _error = 'Por favor verifica tu correo electrónico');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _getErrorMessage(e.code));
    } catch (e) {
      setState(() => _error = 'Error desconocido: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-email':
        return 'Formato de email inválido';
      case 'user-disabled':
        return 'Cuenta deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      default:
        return 'Error de autenticación';
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF0F2F5);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _EmailInput(
                      onSaved: (value) => _email = value!,
                    ),
                    const SizedBox(height: 20),
                    _PasswordInput(
                      onSaved: (value) => _password = value!,
                    ),
                    const SizedBox(height: 20),
                    if (_error.isNotEmpty)
                      Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    _LoginButton(
                      isLoading: _isLoading,
                      onPressed: _handleLogin,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  /* TODO Aqui podrías implementar la logica para "¿Has olvidado la contraseña?"
                  como redirigir a otra pantalla de recuperacion */
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black54,
                ),
                child: const Text('¿Has olvidado la contraseña?'),
              ),
              const SizedBox(height: 40),
              // Botón para Crear cuenta nueva
              _CreateAccountButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  const _EmailInput({required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Correo electrónico',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Campo obligatorio';
        if (!value!.contains('@')) return 'Email inválido';
        return null;
      },
      onSaved: onSaved,
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  const _PasswordInput({required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Contraseña',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) => value?.isEmpty ?? true ? 'Campo obligatorio' : null,
      onSaved: onSaved,
    );
  }
}

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _LoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1877F2);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Iniciar sesión'),
      ),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CreateAccountButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Colors.blueAccent),
      ),
      onPressed: onPressed,
      child: const Text(
        'Crear cuenta nueva',
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}
