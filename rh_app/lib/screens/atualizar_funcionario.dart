// screens/atualizar_funcionario.dart
import 'package:flutter/material.dart';
// O import do CustomAppBar não é mais necessário se não for usado em outro lugar.
// import 'package:rh_app/widgets/custom_app_bar.dart'; 
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

  // << 1. CONTROLADOR DE E-MAIL DECLARADO >>
  late TextEditingController _emailController;
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
    
    // << 2. INICIALIZANDO O CONTROLLER DE E-MAIL >>
    _emailController = TextEditingController(text: widget.funcionario.email);
    _nomeController = TextEditingController(text: widget.funcionario.nome);
    _salarioController = TextEditingController(text: widget.funcionario.salario.toStringAsFixed(2));
    _telefoneController = TextEditingController(text: widget.funcionario.telefone);
    _enderecoController = TextEditingController(text: widget.funcionario.endereco);

    if (_cargos.contains(widget.funcionario.cargo)) {
      _cargoSelecionado = widget.funcionario.cargo;
    }
    if (_statusCivis.contains(widget.funcionario.statusCivil)) {
      _statusCivilSelecionado = widget.funcionario.statusCivil;
    }
    _statusSelecionado = widget.funcionario.status;
  }

  @override
  void dispose() {
    // << 3. LIMPANDO O CONTROLLER DE E-MAIL >>
    _emailController.dispose();
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
        email: _emailController.text, // << 4. E-MAIL ENVIADO NA ATUALIZAÇÃO >>
      );

      _funcionarioService.atualizar(funcionarioAtualizado).then((_) {
        // Adicionando verificação de segurança
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionário atualizado com sucesso!')),
        );
        // Um único pop é geralmente o suficiente para voltar para a tela anterior.
        Navigator.of(context).pop();
      }).catchError((error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar funcionário: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // << 5. APPBAR CORRIGIDO >>
      appBar: AppBar(
        title: const Text('Atualizar Funcionário'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Cor do texto e ícones
        elevation: 1.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Atualizar dados do funcionário:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome', prefixIcon: Icon(Icons.person_outline)),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),

                // << 6. CAMPO DE E-MAIL ADICIONADO AO FORMULÁRIO >>
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email_outlined)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Por favor, insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _salarioController,
                  decoration: const InputDecoration(labelText: 'Salário', prefixText: 'R\$ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(labelText: 'Telefone', prefixIcon: Icon(Icons.phone_outlined)),
                  keyboardType: TextInputType.phone,
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(labelText: 'Endereço', prefixIcon: Icon(Icons.location_on_outlined)),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _cargoSelecionado,
                  decoration: const InputDecoration(labelText: 'Cargo', border: OutlineInputBorder()),
                  items: _cargos.map((cargo) => DropdownMenuItem(value: cargo, child: Text(cargo))).toList(),
                  onChanged: (value) => setState(() => _cargoSelecionado = value),
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _statusCivilSelecionado,
                  decoration: const InputDecoration(labelText: 'Estado Civil', border: OutlineInputBorder()),
                  items: _statusCivis.map((sc) => DropdownMenuItem(value: sc, child: Text(sc))).toList(),
                  onChanged: (value) => setState(() => _statusCivilSelecionado = value),
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 24),

                const Text('Status do Funcionário:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                ToggleButtons(
                  isSelected: [_statusSelecionado == 'Inativo', _statusSelecionado == 'Ativo'],
                  onPressed: (index) => setState(() => _statusSelecionado = index == 0 ? 'Inativo' : 'Ativo'),
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: _statusSelecionado == 'Ativo' ? Colors.green : Colors.red,
                  constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
                  children: const [Text('Inativo'), Text('Ativo')],
                ),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: _atualizar,
                      child: const Text('Atualizar'),
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