// screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard RH')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('Ver Funcionários'),
              onPressed: () => Navigator.pushNamed(context, '/lista'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Cadastrar Funcionário'),
              onPressed: () => Navigator.pushNamed(context, '/cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}