// screens/cadastro_funcionario.dart
import 'package:flutter/material.dart';
import 'package:rh_app/widgets/custom_app_bar.dart';
import '../models/funcionario.dart';
import '../services/funcionario_service.dart';

class CadastroFuncionario extends StatefulWidget {
  const CadastroFuncionario({super.key});

  @override
  State<CadastroFuncionario> createState() => _CadastroFuncionarioState();
}

class _CadastroFuncionarioState extends State<CadastroFuncionario> {
  final _formKey = GlobalKey<FormState>();
  final _funcionarioService = FuncionarioService();

  // Controladores para cada campo do formulário
  final _nomeController = TextEditingController();
  final _salarioController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController(); // NOVO CONTROLADOR
  final _emailController = TextEditingController();

  // Variáveis para os Dropdowns e ToggleButtons
  String? _cargoSelecionado;
  String? _statusCivilSelecionado; // NOVA VARIÁVEL
  String _statusSelecionado = 'Ativo';

  // Listas de opções
  final List<String> _cargos = ['Desenvolvedor', 'UX Designer', 'Recursos Humanos', 'Gerente de Projetos'];
  final List<String> _statusCivis = ['Solteiro(a)', 'Casado(a)', 'Viúvo(a)']; // NOVA LISTA

  @override
  void dispose() {
    _nomeController.dispose();
    _salarioController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose(); // LIMPAR NOVO CONTROLADOR
    _emailController.dispose();
    super.dispose();
  }

  void _salvar() {
  if (_formKey.currentState!.validate()) {
    final novoFuncionario = Funcionario(
      id: '',
      nome: _nomeController.text,
      salario: double.tryParse(_salarioController.text) ?? 0.0,
      telefone: _telefoneController.text,
      cargo: _cargoSelecionado!,
      status: _statusSelecionado,
      endereco: _enderecoController.text,
      statusCivil: _statusCivilSelecionado!,
      email: _emailController.text, // << ADICIONE ESTA LINHA
    );
      _funcionarioService.adicionar(novoFuncionario).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionário cadastrado com sucesso!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar funcionário: $error')),
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
                  'Cadastrar funcionário:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                // --- CAMPO NOME ---
                const Text('Digite o nome:', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),

                // --- CAMPO SALÁRIO ---
                const Text('Digite o salário:', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _salarioController,
                  decoration: const InputDecoration(
                    hintText: 'Salary',
                    prefixText: 'R\$ ', // Prefixo para o salário
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),

                // --- CAMPO TELEFONE ---
                const Text('Digite o telefone:', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(
                    hintText: 'Phone',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),
                
                // --- CAMPO CARGO (DROPDOWN) ---
                const Text('Escolha o cargo:', style: TextStyle(fontSize: 16)),
                DropdownButtonFormField<String>(
                  value: _cargoSelecionado,
                  hint: const Text('Selecione o cargo'),
                  items: _cargos.map((cargo) => DropdownMenuItem(value: cargo, child: Text(cargo))).toList(),
                  onChanged: (value) => setState(() => _cargoSelecionado = value),
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  ),
                ),
                const SizedBox(height: 20),

                const Text('Digite o e-mail:', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (!value.contains('@')) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                const Text('Digite o endereço:', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(
                    hintText: 'Endereço completo',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),

                // --- NOVO CAMPO STATUS CIVIL ---
                const Text('Escolha o estado civil:', style: TextStyle(fontSize: 16)),
                DropdownButtonFormField<String>(
                  value: _statusCivilSelecionado,
                  hint: const Text('Selecione o estado civil'),
                  items: _statusCivis.map((sc) => DropdownMenuItem(value: sc, child: Text(sc))).toList(),
                  onChanged: (value) => setState(() => _statusCivilSelecionado = value),
                  validator: (value) => value == null ? 'Campo obrigatório' : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  ),
                ),
                const SizedBox(height: 20),

                // --- CAMPO STATUS (TOGGLE BUTTONS) ---
                const Text('Defina o status inicial:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                ToggleButtons(
                  isSelected: [_statusSelecionado == 'Inativo', _statusSelecionado == 'Ativo'],
                  onPressed: (index) {
                    setState(() {
                      _statusSelecionado = index == 0 ? 'Inativo' : 'Ativo';
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: _statusSelecionado == 'Ativo' ? Colors.green : Colors.red,
                  children: const [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Inativo')),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Ativo')),
                  ],
                ),
                const SizedBox(height: 32),
                
                // --- BOTÕES DE AÇÃO ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _salvar,
                      child: const Text('Cadastrar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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