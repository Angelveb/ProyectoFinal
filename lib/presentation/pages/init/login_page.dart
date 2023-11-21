import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_v2/componentes/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, 
  this.onTap});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final codeController = TextEditingController();

  void signUserIn() async {
    // Mostrar círculo de carga
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Verificar el código ingresado
    if (codeController.text != "123456") {
      // Ocultar círculo de carga
      Navigator.pop(context);
      // Mostrar mensaje de error al usuario
      displayMessage("Código incorrecto");
      return;
    }

    if (!mounted) {
    return;
  }

  

    // Intentar iniciar sesión
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Ocultar círculo de carga
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Ocultar círculo de carga
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // Usuario incorrecto
      if (e.code == 'user-not-found') {
        //print('Usuario incorrecto');
        wrongEmailMessage();
      }
      // Contraseña incorrecta
      else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(message),
      ));
  }

  // Mensaje de correo incorrecto
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.teal,
          title: Center(
            child: Text(
              'Correo incorrecto',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // Mensaje de contraseña incorrecta
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Contraseña incorrecta'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                child: ClipPath(
                  child: Image.asset('assets/TT.png'),
                ),
              ),
                const SizedBox(
                  height: 30,
                ),
                _buildHeader(),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  hintText: "Correo",
                  validationFunction: (String password) {},
                  showVisibilityIcon: false,
                  fieldIndex: 0,
                  prefixIcon: const Icon(Icons.email),
                  controller: emailController,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hintText: "Contraseña",
                  validationFunction: (String password) {},
                  fieldIndex: 1,
                  prefixIcon: const Icon(Icons.lock),
                  controller: passwordController,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hintText: "Código",
                  validationFunction: (String password) {},
                  showVisibilityIcon: false,
                  fieldIndex: 3,
                  prefixIcon: const Icon(Icons.key),
                  controller: codeController,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 50,
                ),
                      
                /// [Init Account] Button
                MaterialButton(
                  height: 40,
                  minWidth: double.infinity,
                  onPressed: signUserIn,
                  color: const Color(0XFFBA704F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: const Text(
                    "Iniciar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No está registrado?',
                    style: TextStyle(color: Colors.grey[700]),
                      ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Registrese ahora',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header
  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Inicie Sesión",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Ingrese con su cuenta para continuar.",
          style:
              TextStyle(fontSize: 16, height: 1.5, color: Color.fromRGBO(0, 0, 0, 1)),
        ),
      ],
    );
  }

}

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    required this.title,
    required this.isCheck,
  });

  final bool isCheck;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: isCheck ? Colors.green : Colors.transparent,
              border: isCheck
                  ? Border.all(color: Colors.transparent)
                  : Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(50)),
          child: const Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }
}

class AppRegExp {
  AppRegExp._();

  static final numericRegex = RegExp(r'[0-9]');
  static final symRegex = RegExp(r'[!@#$%^&*()]');
  static final hasUpperCase = RegExp(r'[A-Z]');
  static final hasLowerCase = RegExp(r'[a-z]');
}
