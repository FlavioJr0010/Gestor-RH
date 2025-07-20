import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart'; // gerado pelo flutterfire configure

import 'screens/home_screen.dart';
import 'screens/lista_funcionarios.dart';
import 'screens/cadastro_funcionario.dart';
import 'screens/detalhes_funcionario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const RHApp());
}

class RHApp extends StatelessWidget {
  const RHApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RH App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/lista': (context) => const ListaFuncionarios(),
        '/cadastro': (context) => const CadastroFuncionario(),
        '/detalhes': (context) => const DetalhesFuncionario(),
      },
    );
  }
}
