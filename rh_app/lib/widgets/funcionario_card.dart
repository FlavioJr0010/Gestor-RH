// widgets/funcionario_card.dart
import 'package:flutter/material.dart';
import '../models/funcionario.dart';
import '../services/funcionario_service.dart';

class FuncionarioCard extends StatelessWidget {
  final Funcionario funcionario;
  const FuncionarioCard({super.key, required this.funcionario});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(funcionario.nome),
        subtitle: Text('${funcionario.cargo} - ${funcionario.status}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => FuncionarioService().excluir(funcionario.id),
        ),
        onTap: () {
          // Navegar para detalhes futuramente
        },
      ),
    );
  }
}
