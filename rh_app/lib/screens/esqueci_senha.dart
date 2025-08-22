// screens/esqueci_senha.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Necessário para o Timestamp
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import '../services/solicitacao_senha_service.dart'; // Importe o novo serviço

class EsqueciSenha extends StatefulWidget {
  const EsqueciSenha({super.key});

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioService = UsuarioService();
  final _solicitacaoService =
      SolicitacaoSenhaService(); // Instância do novo serviço

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _emailVerificado = false;
  Usuario? _usuarioParaAtualizar;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ETAPA 1: Verifica se o e-mail existe (lógica inalterada)
  Future<void> _verificarEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final usuario = await _usuarioService.buscarPorEmail(
        _emailController.text.trim(),
      );
      if (mounted) {
        if (usuario != null) {
          setState(() {
            _usuarioParaAtualizar = usuario;
            _emailVerificado = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nenhum usuário encontrado para este e-mail.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _enviarSolicitacao() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final dadosSolicitacao = {
        'usuarioId': _usuarioParaAtualizar!.id,
        'usuarioEmail': _usuarioParaAtualizar!.email,
        'usuarioNome':
            _usuarioParaAtualizar!.nome, // Adiciona o nome do usuário
        'novaSenhaSugerida': _passwordController.text,
        'dataSolicitacao': Timestamp.now(),
      };

      await _solicitacaoService.criarSolicitacao(dadosSolicitacao);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sua solicitação foi enviada para análise!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // ... (tratamento de erro)
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sua AppBar foi removida no código anterior, mantive assim.
      // Se precisar dela de volta, pode usar o CustomAppBar.
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Esqueceu sua senha?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Insira seu e-mail de cadastro para continuar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  readOnly: _emailVerificado,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      (value == null ||
                          value.trim().isEmpty ||
                          !value.contains('@'))
                      ? 'Por favor, insira um e-mail válido.'
                      : null,
                ),
                const SizedBox(height: 24),

                if (_emailVerificado)
                  Column(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Nova Senha Sugerida',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Por favor, sugira uma senha.';
                          if (value.length < 6)
                            return 'A senha deve ter no mínimo 6 caracteres.';
                          if (value == _usuarioParaAtualizar?.senha)
                            return 'A nova senha não pode ser igual à anterior.';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Nova Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text)
                            return 'As senhas não coincidem.';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          side: BorderSide(color: Colors.grey[400]!),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('CANCELAR'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        // A função do botão agora é a correta para cada etapa
                        onPressed: _isLoading
                            ? null
                            : (_emailVerificado
                                  ? _enviarSolicitacao
                                  : _verificarEmail),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            // O texto do botão também foi atualizado
                            : Text(
                                _emailVerificado
                                    ? 'ENVIAR SOLICITAÇÃO'
                                    : 'VERIFICAR E-MAIL',
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
