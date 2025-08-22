//Import
import 'package:flutter/material.dart';
import 'package:rh_app/screens/esqueci_senha.dart';
import 'auth_check.dart';

//Firebase
import 'firebase_options.dart'; // gerado pelo flutterfire configure
import 'package:firebase_core/firebase_core.dart';

//Screens
//import 'screens/home_screen.dart';
import 'screens/lista_funcionarios.dart';
import 'screens/cadastro_funcionario.dart';
//import 'screens/detalhes_funcionario.dart';
import 'package:rh_app/screens/cadastro_email.dart';
import 'package:rh_app/screens/login.dart';
import 'package:rh_app/screens/principal.dart';
import 'package:rh_app/screens/tela_adm.dart';



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
      // O home agora é o AuthCheck!
      home: const AuthCheck(),
      routes: {
        //'/': (context) => const HomeScreen(),
        '/lista': (context) => const ListaFuncionarios(),
        '/cadastro': (context) => const CadastroFuncionario(),
       // '/detalhes': (context) => const DetalhesFuncionario(),
        '/login': (context) => const Login(),
        '/cadastro-email': (context) => CadastroEmail(),
        '/principal': (context) => Principal(),
        '/esqueci-senha': (context) => EsqueciSenha(),
        '/adm': (context) => TelaAdm(),
      },
    );
  }
}
