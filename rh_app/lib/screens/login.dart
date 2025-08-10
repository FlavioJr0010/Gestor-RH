// screens/login.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importe seu modelo e serviço de usuário
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioService = UsuarioService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE LOGIN ---
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // --- CASO ESPECIAL DO ADMIN ---
      if (email == 'admin' && password == 'admin') {
        Navigator.pushReplacementNamed(context, '/adm');
        return; // Para a execução aqui
      }

      try {
        // --- LÓGICA PARA USUÁRIOS NORMAIS ---
        final Usuario? usuario = await _usuarioService.buscarPorEmail(email);

        if (usuario == null) {
          // Usuário não encontrado
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('E-mail não encontrado.'), backgroundColor: Colors.red),
          );
        } else if (usuario.senha != password) {
          // Senha incorreta
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Senha incorreta.'), backgroundColor: Colors.red),
          );
        } else {
          // --- SUCESSO NO LOGIN ---
          // Salva o ID do usuário para mantê-lo logado
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('usuario_id', usuario.id);
          await prefs.setString('usuario_nome', usuario.nome); // Salva o nome também

          // Navega para a tela principal
          Navigator.pushReplacementNamed(context, '/principal');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer login: $e'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Envolve o Column com um Form
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Image.asset('images/GestorRHLogo.png', height: 100),
                const SizedBox(height: 24),
                const Text('Sign In', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 48),

                // --- Campo Email com Validação ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Por favor, insira o e-mail.' : null,
                ),
                const SizedBox(height: 16),

                // --- Campo Senha com Validação ---
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                   validator: (value) => (value == null || value.isEmpty) ? 'Por favor, insira a senha.' : null,
                ),
                const SizedBox(height: 8),

                 Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/esqueci-senha'),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 24),
                
                // --- Botão de Login com Lógica de Carregamento ---
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text('Log In', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 48),

                 RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    children: [
                      const TextSpan(text: 'Still without account? '),
                      TextSpan(
                        text: 'Register now',
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, '/cadastro-email'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}