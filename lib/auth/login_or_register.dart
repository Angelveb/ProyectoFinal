import 'package:flutter/material.dart';
import 'package:proyecto_v2/presentation/pages/init/login_page.dart';
import 'package:proyecto_v2/presentation/pages/init/register_page.dart';


class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  
  // Mostrar inicialmente inicio de sesion
  bool showLoginPage = true;

  // Alternar ente pagina de inicio de sesion y pagina de registro
  void togglePages(){
    setState((){
    showLoginPage = !showLoginPage;
  });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(onTap: togglePages);
    } else {
    return RegisterPage(onTap: togglePages);
  }
}
}