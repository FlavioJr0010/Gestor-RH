// screens/principal.dart
import 'package:flutter/material.dart';
import '../models/funcionario.dart';
import '../services/funcionario_service.dart';
import '../widgets/funcionario_card.dart';
import '../widgets/custom_app_bar.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final FuncionarioService _service = FuncionarioService();
  String _busca = ''; // Estado para armazenar o texto da busca

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. O CustomAppBar vai sozinho aqui, sem nenhum parâmetro.
      appBar: const CustomAppBar(),
      
      backgroundColor: Colors.white,

      // 2. Todo o conteúdo da tela vai aqui, no body do Scaffold.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de busca e botão de adicionar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _busca = value; // Atualiza o estado da busca
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
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
                  onPressed: () {
                    // Navega para a tela de cadastro
                    Navigator.pushNamed(context, '/cadastro');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Título da lista
            const Text(
              'Funcionário cadastrados:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Lista de funcionários
            Expanded(
              child: StreamBuilder<List<Funcionario>>(
                stream: _service.buscarPorNome(_busca),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum funcionário encontrado.'));
                  }

                  final funcionarios = snapshot.data!;
                  return ListView.builder(
                    itemCount: funcionarios.length,
                    itemBuilder: (context, index) {
                      return FuncionarioCard(funcionario: funcionarios[index]);
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