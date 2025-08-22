// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  // MUDANÇA 1: Adicionamos um novo parâmetro opcional.
  final bool hideBackButton;

  const CustomAppBar({
    super.key,
    this.hideBackButton = false, // O valor padrão é 'false', então as outras telas não quebram.
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String _nomeUsuario = 'Usuário';

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
  }

  Future<void> _carregarNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _nomeUsuario = prefs.getString('usuario_nome') ?? 'Usuário';
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_id');
    await prefs.remove('usuario_nome');
    
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _irParaPrincipal() {
    Navigator.pushNamedAndRemoveUntil(context, '/principal', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      
      // MUDANÇA 2: A lógica para mostrar o botão de voltar agora usa nosso novo parâmetro.
      automaticallyImplyLeading: !widget.hideBackButton && Navigator.canPop(context),

      iconTheme: const IconThemeData(color: Colors.black87),
      title: GestureDetector(
        onTap: _irParaPrincipal,
        child: Image.asset('images/GestorRHLogo.png', height: 35),
      ),
      actions: [
        Center(child: Text("Olá, $_nomeUsuario!", style: const TextStyle(color: Colors.black))),
        const SizedBox(width: 8),
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