import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Importe seu modelo e serviço de usuário
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class CadastroEmail extends StatefulWidget {
  const CadastroEmail({super.key});

  @override
  State<CadastroEmail> createState() => _CadastroEmailState();
}

class _CadastroEmailState extends State<CadastroEmail> {
  // Chave global para identificar e validar nosso formulário
  final _formKey = GlobalKey<FormState>();

  // Instância do nosso serviço de usuário
  final _usuarioService = UsuarioService();

  // Controladores para os campos de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Variáveis de estado
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false; // Para controlar o indicador de carregamento

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE CADASTRO ---
  Future<void> _cadastrarUsuario() async {
    // 1. Validar o formulário
    if (_formKey.currentState!.validate()) {
      // Mostra o indicador de carregamento e desabilita o botão
      setState(() {
        _isLoading = true;
      });

      try {
        // 2. Verificar se o e-mail já existe
        final usuarioExistente = await _usuarioService.buscarPorEmail(_emailController.text.trim());
        if (usuarioExistente != null) {
          // Se o usuário existir, mostra um erro
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este e-mail já está em uso.'), backgroundColor: Colors.red),
          );
          return; // Para a execução
        }

        // 3. Se o e-mail não existir, cria o novo usuário
        final novoUsuario = Usuario(
          id: '', // O ID será gerado pelo Firebase
          nome: _nameController.text.trim(),
          email: _emailController.text.trim(),
          senha: _passwordController.text, // Lembre-se: em produção, use Firebase Auth!
        );

        // 4. Adicionar ao Firestore
        await _usuarioService.adicionar(novoUsuario);

        // 5. Mostrar mensagem de sucesso e voltar para a tela de login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada com sucesso!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);

      } catch (e) {
        // Se der algum erro na comunicação com o Firebase
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar conta: $e'), backgroundColor: Colors.red),
        );
      } finally {
        // Esconde o indicador de carregamento
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          // Adiciona o widget Form e a chave
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 50),
                Image.asset('images/GestorRHLogo.png', height: 80),
                const SizedBox(height: 20),
                const Text('Create your account', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  '"Create your account to start your journey with the best HR system!"',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),

                // --- Campo Nome com Validação ---
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline), border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira seu nome.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- Campo Email com Validação ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.email_outlined), border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira um e-mail.';
                    }
                    // Validação simples de formato de e-mail
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Por favor, insira um e-mail válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- Campo Senha com Validação ---
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const UnderlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha.';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- Campo Confirmar Senha com Validação ---
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const UnderlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                    ),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // --- Botão de Cadastro com Lógica de Carregamento ---
                ElevatedButton(
                  // Desabilita o botão enquanto está carregando
                  onPressed: _isLoading ? null : _cadastrarUsuario,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading
                      // Mostra o indicador de progresso se estiver carregando
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      // Mostra o texto normal se não estiver carregando
                      : const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 24),

                // --- Texto para voltar ao Login ---
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    children: [
                      const TextSpan(text: 'Already have account? '),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
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