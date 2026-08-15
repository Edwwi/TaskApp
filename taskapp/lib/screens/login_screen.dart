import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  bool _isLogin = true;
  bool _isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      String? error;
      if (_isLogin) {
        error = await _authService.signInWithEmail(_email, _password);
      } else {
        error = await _authService.registerWithEmail(
          _email, 
          _password, 
          _firstName, 
          _lastName,
        );
      }

      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
      
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 80,
                ),
                const SizedBox(height: 24),
                Text(
                  _isLogin ? 'Iniciar Sesión' : 'Crear Cuenta',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                if (!_isLogin) ...[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
                    onSaved: (val) => _firstName = val!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
                    onSaved: (val) => _lastName = val!,
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val!.contains('@') ? null : 'Email inválido',
                  onSaved: (val) => _email = val!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Mínimo 6 caracteres' : null,
                  onSaved: (val) => _password = val!,
                ),
                const SizedBox(height: 24),
                if (_isLoading)
                  const CircularProgressIndicator()
                else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? 'Entrar' : 'Registrarse'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(_isLogin 
                      ? '¿No tienes cuenta? Regístrate' 
                      : '¿Ya tienes cuenta? Inicia sesión'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
