// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'dart:async'; // Importe para usar o Timer

// 1. Mude de StatelessWidget para StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // 2. Adicione o método initState para iniciar o timer
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      // 3. Após 2 segundos, navegue para a tela de login
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  // 4. No método build, mostre a sua logo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/GestorRhSemFundo.png', // Verifique se este é o nome correto do arquivo
          width: 250, // Ajuste o tamanho se precisar
        ),
      ),
    );
  }
}