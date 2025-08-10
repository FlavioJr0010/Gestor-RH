// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login.dart';

// Usamos StatefulWidget porque precisamos carregar o nome do usuário do SharedPreferences,
// o que é uma operação assíncrona. Também implementamos PreferredSizeWidget
// para que o Flutter saiba a altura da nossa AppBar.
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Altura padrão de uma AppBar
}

class _CustomAppBarState extends State<CustomAppBar> {
  String _nomeUsuario = 'Usuário'; // Valor padrão

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
  }

  // Carrega o nome do usuário salvo no SharedPreferences
  Future<void> _carregarNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    // Se o widget ainda estiver na tela, atualiza o estado
    if (mounted) {
      setState(() {
        _nomeUsuario = prefs.getString('usuario_nome') ?? 'Usuário';
      });
    }
  }

  // Lógica de logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_id');
    await prefs.remove('usuario_nome');
    
    if (mounted) {
      // Navega para a tela de login e remove todas as outras telas da pilha
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (Route<dynamic> route) => false,
      );
    }
  }

  // Navega para a tela principal, limpando a pilha de navegação
  void _irParaPrincipal() {
    Navigator.pushNamedAndRemoveUntil(context, '/principal', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      // Se houver uma tela anterior, mostra o botão de voltar automaticamente
      automaticallyImplyLeading: Navigator.canPop(context), 
      iconTheme: const IconThemeData(color: Colors.black87), // Cor do ícone de voltar
      title: GestureDetector(
        onTap: _irParaPrincipal, // A logo agora é um botão para a tela principal
        child: Image.asset('images/GestorRHLogo.png', height: 35),
      ),
      actions: [
        Center(child: Text("Olá, $_nomeUsuario!", style: const TextStyle(color: Colors.black))),
        const SizedBox(width: 8),
        // Menu de opções (logout)
        PopupMenuButton(
          icon: const CircleAvatar(child: Icon(Icons.person)),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'logout') {
              _logout();
            }
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}