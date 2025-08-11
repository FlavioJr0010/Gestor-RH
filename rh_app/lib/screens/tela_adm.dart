import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rh_app/models/funcionario.dart';
import 'package:rh_app/services/funcionario_service.dart';
import 'package:rh_app/screens/atualizar_funcionario.dart';

class TelaAdm extends StatefulWidget {
  const TelaAdm({super.key});

  @override
  State<TelaAdm> createState() => _TelaAdmState();
}

class _TelaAdmState extends State<TelaAdm> {
  final FuncionarioService _service = FuncionarioService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _busca = '';

  void _mostrarDialogoDeExclusao(Funcionario funcionario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir ${funcionario.nome}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
              onPressed: () {
                _service.excluir(funcionario.id).then((_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${funcionario.nome} foi excluído.')),
                  );
                }).catchError((error) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao excluir: $error')),
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navegarParaEdicao(Funcionario funcionario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AtualizarFuncionario(funcionario: funcionario),
      ),
    );
  }

  void _enviarEmailResetSenha(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Redefinir Senha'),
          content: Text('Um e-mail será enviado para $email com instruções para redefinir a senha. Deseja continuar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Enviar'),
              onPressed: () {
                _auth.sendPasswordResetEmail(email: email).then((_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('E-mail de redefinição enviado para $email.')),
                  );
                }).catchError((error) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao enviar e-mail: $error')),
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel do Administrador"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _busca = value),
                    decoration: InputDecoration(
                      hintText: 'Buscar funcionário...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue, size: 40),
                  onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Gerenciar Funcionários e Acessos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Funcionario>>(
                stream: _service.buscarPorNome(_busca),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum funcionário encontrado.'));
                  }
                  final funcionarios = snapshot.data!;
                  return ListView.builder(
                    itemCount: funcionarios.length,
                    itemBuilder: (context, index) {
                      final funcionario = funcionarios[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(funcionario.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(funcionario.email), // Exibindo o e-mail diretamente
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // << BOTÃO DE RESET DE SENHA INTEGRADO >>
                              IconButton(
                                icon: const Icon(Icons.password_rounded, color: Colors.blueGrey),
                                tooltip: 'Redefinir Senha do Usuário',
                                onPressed: () {
                                  if (funcionario.email.isNotEmpty) {
                                    _enviarEmailResetSenha(funcionario.email);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Funcionário sem e-mail cadastrado.')),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                tooltip: 'Editar Dados do Funcionário',
                                onPressed: () => _navegarParaEdicao(funcionario),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Excluir Funcionário',
                                onPressed: () => _mostrarDialogoDeExclusao(funcionario),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}