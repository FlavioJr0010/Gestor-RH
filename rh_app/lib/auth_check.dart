// lib/auth_check.dart
import 'package:flutter/material.dart';
import 'package:rh_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'screens/login.dart';
import 'screens/principal.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    _verificarLogin();
  }

  Future<void> _verificarLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // Tenta pegar o ID do usuário salvo. Se não existir, será null.
    final String? usuarioId = prefs.getString('usuario_id');

    if (mounted) { // Garante que o widget ainda está na tela
      if (usuarioId != null) {
        // Se tem um ID salvo, vai direto para a tela principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Principal()),
        );
      } else {
        // Se não tem, vai para a tela Home Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mostra uma tela de carregamento enquanto verifica
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}