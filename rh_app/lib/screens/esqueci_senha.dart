import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EsqueciSenha extends StatefulWidget {
  const EsqueciSenha({super.key});

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Variáveis de estado para controlar a UI
  bool _isLoading = false;
  bool _emailFound = false;
  String? _documentIdToUpdate; // Para guardar o ID do documento encontrado

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Função para buscar o e-mail no Firestore
  Future<void> _searchEmail() async {
    if (_emailController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // << MUDANÇA AQUI: Buscando na coleção 'usuarios' >>
      // Se o nome da sua coleção for diferente, altere a linha abaixo.
      final querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios') // Alterado de 'funcionarios' para 'usuarios'
          .where('email', isEqualTo: _emailController.text.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // E-mail encontrado!
        setState(() {
          _emailFound = true;
          _documentIdToUpdate = querySnapshot.docs.first.id;
        });
      } else {
        // E-mail não encontrado
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('E-mail não encontrado na base de dados.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao buscar e-mail: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Função para confirmar e salvar a nova senha
  Future<void> _confirmNewPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // << MUDANÇA AQUI: Atualizando na coleção 'usuarios' >>
        await FirebaseFirestore.instance
            .collection('usuarios') // Alterado de 'funcionarios' para 'usuarios'
            .doc(_documentIdToUpdate)
            .update({'senha': _passwordController.text}); // Supondo que o campo se chame 'senha'

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Senha alterada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar senha: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ícone
                Icon(
                  Icons.person_search,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),

                // Seção de busca de e-mail
                const Text(
                  'Enter your email:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // O campo de e-mail fica desabilitado após a busca
                  enabled: !_emailFound,
                ),
                const SizedBox(height: 16),
                // O botão de busca só aparece se o e-mail ainda não foi encontrado
                if (!_emailFound)
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _searchEmail,
                          child: const Text('SEARCH'),
                        ),

                // Seção de nova senha (só aparece se o e-mail for encontrado)
                if (_emailFound) ...[
                  const SizedBox(height: 32),
                  const Text(
                    'Enter your new password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'As senhas não coincidem.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _confirmNewPassword,
                          child: const Text('CONFIRM'),
                        ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
