import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_v2/Auth/login_or_register.dart';
import 'package:proyecto_v2/presentation/pages/home/home_page.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          
          // Usuario logueado
          if(snapshot.hasData){
            return const HomePage();
          }
          // Usuario no logueado
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}