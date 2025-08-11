import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EsqueciSenha extends StatefulWidget {
  const EsqueciSenha({super.key});

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  // Chave para validar o formulário
  final _formKey = GlobalKey<FormState>();
  // Controlador para o campo de texto do e-mail
  final _emailController = TextEditingController();
  // Instância do Firebase Auth para usar suas funções
  final _auth = FirebaseAuth.instance;

  // Variável para controlar o estado de carregamento
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Função que será chamada ao pressionar o botão
  Future<void> _enviarEmailRecuperacao() async {
    // 1. Valida se o formulário foi preenchido corretamente
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return; // Se o formulário não for válido, não faz nada.
    }

    // 2. Ativa o indicador de carregamento
    setState(() {
      _isLoading = true;
    });

    try {
      // 3. Tenta enviar o e-mail de redefinição de senha para o endereço fornecido
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());

      // 4. Se o envio foi bem-sucedido, mostra uma mensagem de sucesso.
      // A verificação 'mounted' garante que o widget ainda está na tela antes de usar o 'context'.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail de recuperação enviado! Verifique sua caixa de entrada.'),
          backgroundColor: Colors.green,
        ),
      );

      // Opcional: Aguarda um segundo para o usuário ver a mensagem e depois volta para a tela anterior.
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pop();
      }

    } on FirebaseAuthException catch (e) {
      // 5. Trata erros específicos do Firebase (como e-mail não encontrado)
      if (!mounted) return;

      String errorMessage = 'Ocorreu um erro. Tente novamente.';
      // Mapeia os códigos de erro mais comuns para mensagens amigáveis
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhum usuário encontrado para este e-mail.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'O formato do e-mail fornecido é inválido.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // 6. Trata qualquer outro erro inesperado que possa ocorrer
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro inesperado. Por favor, tente mais tarde.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // 7. Garante que o indicador de carregamento seja desativado, não importa o que aconteça
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ícone similar ao da sua imagem
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),

                // Título
                const Text(
                  'Esqueceu sua senha?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sem problemas. Insira seu e-mail abaixo e enviaremos um link para você criar uma nova senha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Campo de E-mail
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'seuemail@exemplo.com',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Por favor, insira um e-mail válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Botão de Enviar
                // Mostra um indicador de progresso se estiver carregando
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _enviarEmailRecuperacao,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'ENVIAR E-MAIL DE RECUPERAÇÃO',
                          style: TextStyle(fontSize: 16),
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
