import 'package:flutter/material.dart';


class TelaAdm extends StatelessWidget {
  const TelaAdm({super.key});


    @override
  Widget build(BuildContext context) {
    // É aqui que você vai construir a aparência da sua tela.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Administrativa'),
      ),
      body: Container(), // Comece com um container ou o widget que desejar.
    );
  }
}