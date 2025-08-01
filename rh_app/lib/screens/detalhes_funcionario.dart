// screens/detalhes_funcionario.dart
import 'package:flutter/material.dart';
import 'package:rh_app/screens/atualizar_funcionario.dart';
import '../models/funcionario.dart';
import '../services/funcionario_service.dart';

class DetalhesFuncionario extends StatelessWidget {
  final Funcionario funcionario;

  const DetalhesFuncionario({super.key, required this.funcionario});

  @override
  Widget build(BuildContext context) {
    // Função para mostrar um diálogo de confirmação
    void mostrarDialogoConfirmacao() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: Text(
              'Tem certeza que deseja remover ${funcionario.nome}?',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
              ),
              TextButton(
                child: const Text(
                  'Remover',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  FuncionarioService().excluir(funcionario.id);
                  Navigator.of(context).pop(); // Fecha o diálogo
                  Navigator.of(context).pop(); // Volta para a lista
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(funcionario.nome),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Faz a coluna se ajustar ao conteúdo
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      funcionario.nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 30),
                  _buildDetailRow('Cargo:', funcionario.cargo),
                  _buildDetailRow(
                    'Salário:',
                    'R\$ ${funcionario.salario.toStringAsFixed(2)}',
                  ),
                  _buildDetailRow('Telefone:', funcionario.telefone),
                  _buildDetailRow('Status:', funcionario.status),
                  _buildDetailRow('Endereço:', funcionario.endereco),
                  _buildDetailRow('Status Civil:', funcionario.statusCivil),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                        onPressed: () {
                          // ✅ NAVEGAÇÃO ADICIONADA AQUI
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AtualizarFuncionario(
                                funcionario: funcionario,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                        ),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text('Remover'),
                        onPressed: mostrarDialogoConfirmacao,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para criar as linhas de detalhe
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
