// screens/atualizar_funcionario.dart
import 'package:flutter/material.dart';
import 'package:rh_app/widgets/custom_app_bar.dart';
import '../models/funcionario.dart';
import '../services/funcionario_service.dart';

class AtualizarFuncionario extends StatefulWidget {
  final Funcionario funcionario;
  const AtualizarFuncionario({super.key, required this.funcionario});

  @override
  State<AtualizarFuncionario> createState() => _AtualizarFuncionarioState();
}

class _AtualizarFuncionarioState extends State<AtualizarFuncionario> {
  final _formKey = GlobalKey<FormState>();
  final _funcionarioService = FuncionarioService();

  late TextEditingController _nomeController;
  late TextEditingController _salarioController;
  late TextEditingController _telefoneController;
  late TextEditingController _enderecoController;
  String? _cargoSelecionado;
  String? _statusCivilSelecionado;
  String _statusSelecionado = 'Ativo';

  final List<String> _cargos = ['Desenvolvedor', 'UX Designer', 'Recursos Humanos', 'Gerente de Projetos'];
  final List<String> _statusCivis = ['Solteiro(a)', 'Casado(a)', 'Viúvo(a)'];

@override
void initState() {
  super.initState();
  

  _nomeController = TextEditingController(text: widget.funcionario.nome);
  _salarioController = TextEditingController(text: widget.funcionario.salario.toStringAsFixed(2));
  _telefoneController = TextEditingController(text: widget.funcionario.telefone);
  _enderecoController = TextEditingController(text: widget.funcionario.endereco);

  // Verifica se o cargo do funcionário existe na nossa lista de opções
  if (_cargos.contains(widget.funcionario.cargo)) {
    _cargoSelecionado = widget.funcionario.cargo;
  } 
  // Se não existir, _cargoSelecionado continuará null e o hintText "Selecione o cargo" aparecerá

  // Verifica se o estado civil do funcionário existe na nossa lista
  if (_statusCivis.contains(widget.funcionario.statusCivil)) {
    _statusCivilSelecionado = widget.funcionario.statusCivil;
  }
  // Se não existir, _statusCivilSelecionado continuará null

  _statusSelecionado = widget.funcionario.status;
}

  @override
  void dispose() {
    _nomeController.dispose();
    _salarioController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  void _atualizar() {
    if (_formKey.currentState!.validate()) {
      final funcionarioAtualizado = Funcionario(
        id: widget.funcionario.id,
        nome: _nomeController.text,
        salario: double.tryParse(_salarioController.text.replaceAll(',', '.')) ?? 0.0,
        telefone: _telefoneController.text,
        cargo: _cargoSelecionado!,
        status: _statusSelecionado,
        endereco: _enderecoController.text,
        statusCivil: _statusCivilSelecionado!,
      );

      _funcionarioService.atualizar(funcionarioAtualizado).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionário atualizado com sucesso!')),
        );
        Navigator.of(context)..pop()..pop();
      }).catchError((error) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar funcionário: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Atualizar funcionário:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // --- INÍCIO DO FORMULÁRIO COMPLETO ---

                const Text('Digite o nome:', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline)),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),

                const Text('Digite o salário:', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _salarioController,
                  decoration: const InputDecoration(prefixText: 'R\$ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),

                const Text('Digite o telefone:', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.phone_outlined)),
                  keyboardType: TextInputType.phone,
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),

                const Text('Escolha o cargo:', style: TextStyle(fontSize: 16)),
                DropdownButtonFormField<String>(
                  value: _cargoSelecionado,
                  items: _cargos.map((cargo) => DropdownMenuItem(value: cargo, child: Text(cargo))).toList(),
                  onChanged: (value) => setState(() => _cargoSelecionado = value),
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                  decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                ),
                const SizedBox(height: 20),

                const Text('Digite o endereço:', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on_outlined)),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),

                const Text('Escolha o estado civil:', style: TextStyle(fontSize: 16)),
                DropdownButtonFormField<String>(
                  value: _statusCivilSelecionado,
                  items: _statusCivis.map((sc) => DropdownMenuItem(value: sc, child: Text(sc))).toList(),
                  onChanged: (value) => setState(() => _statusCivilSelecionado = value),
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                  decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                ),
                const SizedBox(height: 20),

                const Text('Defina o status:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                ToggleButtons(
                  isSelected: [_statusSelecionado == 'Inativo', _statusSelecionado == 'Ativo'],
                  onPressed: (index) => setState(() => _statusSelecionado = index == 0 ? 'Inativo' : 'Ativo'),
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: _statusSelecionado == 'Ativo' ? Colors.green : Colors.red,
                  children: const [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Inativo')),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Ativo')),
                  ],
                ),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red, side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _atualizar,
                      child: const Text('Atualizar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                    ),
                  ],
                ),
                // --- FIM DO FORMULÁRIO COMPLETO ---
              ],
            ),
          ),
        ),
      ),
    );
  }
}