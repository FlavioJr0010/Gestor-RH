// screens/lista_funcionarios.dart
import 'package:flutter/material.dart';
import '../services/funcionario_service.dart';
import '../widgets/funcionario_card.dart';

class ListaFuncionarios extends StatelessWidget {
  const ListaFuncionarios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Funcionários')),
      body: StreamBuilder(
        stream: FuncionarioService().listarTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Erro ao carregar dados'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final funcionarios = snapshot.data!;

          return ListView.builder(
            itemCount: funcionarios.length,
            itemBuilder: (context, index) => FuncionarioCard(funcionario: funcionarios[index]),
          );
        },
      ),
    );
  }
}