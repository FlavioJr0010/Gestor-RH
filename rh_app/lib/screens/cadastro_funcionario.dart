// screens/cadastro_funcionario.dart
import 'package:flutter/material.dart';
import '../models/funcionario.dart';
import '../services/funcionario_service.dart';

class CadastroFuncionario extends StatefulWidget {
  const CadastroFuncionario({super.key});

  @override
  State<CadastroFuncionario> createState() => _CadastroFuncionarioState();
}

class _CadastroFuncionarioState extends State<CadastroFuncionario> {
  final _formKey = GlobalKey<FormState>();
  String nome = '', cargo = '', status = 'Ativo';

  void salvarFuncionario() {
    if (_formKey.currentState!.validate()) {
      final funcionario = Funcionario(
        id: '',
        nome: nome,
        cargo: cargo,
        status: status,
      );
      FuncionarioService().adicionar(funcionario);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                onChanged: (val) => nome = val,
                validator: (val) => val!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cargo'),
                onChanged: (val) => cargo = val,
                validator: (val) => val!.isEmpty ? 'Informe o cargo' : null,
              ),
              DropdownButtonFormField(
                value: status,
                items: const [
                  DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                  DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
                ],
                onChanged: (val) => setState(() => status = val!),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: salvarFuncionario,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
