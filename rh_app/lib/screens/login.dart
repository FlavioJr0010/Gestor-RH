import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 1. Convertendo para StatefulWidget
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // 2. Variável para controlar a visibilidade da senha
  bool _isPasswordVisible = false;

  // 3. Controladores para obter o texto dos campos
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 4. É importante liberar os controladores da memória quando a tela é destruída
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos SafeArea para evitar que o conteúdo fique sob a barra de status/notificações
    return SafeArea(
      child: Scaffold(
        // Removi a AppBar para um visual mais limpo, como no seu design
        body: SingleChildScrollView(
          // Padding para dar um respiro nas laterais
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Espaçamento no topo
              const SizedBox(height: 60),

              // Logo
              Image.asset(
                'images/GestorRHLogo.png',
                height: 100, // Ajuste a altura conforme necessário
              ),
              const SizedBox(height: 24),

              // Texto "Sign In"
              const Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Subtítulo
              Text(
                'Welcome to your better HR system',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),

              // Campo de Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de Senha
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Controla a visibilidade
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  // Ícone para mostrar/esconder a senha
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      // setState atualiza a tela com o novo valor
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              // Botão "Forgot Password?"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Adicionar lógica para "esqueci a senha"
                    Navigator.pushNamed(context, '/esqueci-senha');
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 24),

              // Botão de Login
              ElevatedButton(
                onPressed: () {
                  // TODO: Adicionar lógica de login
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  print('Login com Email: $email e Senha: $password');

                  // Lógica de login temporária
                  Navigator.pushReplacementNamed(context, '/principal');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 48),

              // Texto de Cadastro
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                  children: [
                    const TextSpan(text: 'Still without account? '),
                    TextSpan(
                      text: 'Register now',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      // Adiciona um reconhecedor de gestos para tornar o texto clicável
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: Adicionar navegação para a tela de cadastro
                          Navigator.pushNamed(context, '/cadastro-email');
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}