// widgets/funcionario_card.dart
import 'package:flutter/material.dart';
import '../models/funcionario.dart';
import '../screens/detalhes_funcionario.dart';

class FuncionarioCard extends StatelessWidget {
  final Funcionario funcionario;
  const FuncionarioCard({super.key, required this.funcionario});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalhesFuncionario(funcionario: funcionario),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ A SOLUÇÃO ESTÁ AQUI 👇
              Expanded(
                // O Expanded diz para esta coluna ocupar todo o espaço restante na Row.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      funcionario.nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      // Opcional: para nomes muito longos, pode adicionar reticências
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      funcionario.cargo,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16), // Espaçamento entre o texto e o chip
              // Chip de Status (Ativo/Inativo)
              Chip(
                label: Text(
                  funcionario.status,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: funcionario.status == 'Ativo' ? Colors.green : Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}