import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_v2/components/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasSymbols = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();

  void signUserUp() async {
  // Mostrar círculo de carga
  showDialog(
    context: context,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    // make sure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      // pop loading circle
      _tryPopDialog();
      // show error to user
      displayMessage("Las contraseñas no coinciden");
      return;
    }

    // Verificar el código ingresado
    if (codeController.text != "123456") {
      // Ocultar círculo de carga
      _tryPopDialog();
      // Mostrar mensaje de error al usuario
      displayMessage("Código incorrecto");
      return;
    }

    if (!mounted) {
      return;
    }

    // try creating the user
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    // after crearign the user, create a new document in cloud firestore called users
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential.user!.email)
        .set({
      'nombre': emailController.text.split('@')[0], // initial username
      'rool': 'Rool vacío..', // Initially biografia vacia
      'torre': 'Torre vacía..', // Initially biografia vacia
      'apartamento': 'Apartamento vacío..', // Initially biografia vacia
      'foto_perfil': 'Foto vacía..' // Initially biografia vacia
      // add any additional fields as needed     
    });

    // pop loading circle
    _tryPopDialog();
  } on FirebaseAuthException catch (e) {
    // pop loading circle
    _tryPopDialog();
    // show custom error message
    if (e.code == 'email-already-in-use') {
      displayMessage("Este correo ya existe");
    } else {
      displayMessage(e.code);
    }
  }
}

void _tryPopDialog() {
  try {
    if (context.mounted) Navigator.pop(context);
  } catch (e) {
    print('Error during widget disposal: $e');
  }
}

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
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
        });
  }

  // Mensaje de contraseña incorrecta
  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Contraseña incorrecta'),
          );
        });
  }

  void showErrorMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Contraseñas no coinciden'),
          );
        });
  }

  /// Validation
  void passwordValidator(String password) {
    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 6) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (AppRegExp.numericRegex.hasMatch(password)) {
        _hasPasswordOneNumber = true;
      }

      _hasSymbols = false;
      if (AppRegExp.symRegex.hasMatch(password)) _hasSymbols = true;

      _hasUpperCase = false;
      if (AppRegExp.hasUpperCase.hasMatch(password)) _hasUpperCase = true;

      _hasLowerCase = false;
      if (AppRegExp.hasLowerCase.hasMatch(password)) _hasLowerCase = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFFFFFFF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                _buildHeader(),
                const SizedBox(
                  height: 30,
                ),
                CustomTile(
                  isCheck: _isPasswordEightCharacters,
                  title: "Contiene al menos 6 caracteres",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTile(
                  isCheck: _hasUpperCase,
                  title: "Contiene mayúsculas",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTile(
                  isCheck: _hasLowerCase,
                  title: "Contiene minúsculas",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTile(
                  isCheck: _hasPasswordOneNumber,
                  title: "Contiene al menos 1 número",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTile(
                  isCheck: _hasSymbols,
                  title: "Contiene símbolos (?#@)",
                ),
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
                  validationFunction: passwordValidator,
                  fieldIndex: 1,
                  prefixIcon: const Icon(Icons.lock),
                  controller: passwordController,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hintText: "Confirmar contraseña",
                  validationFunction: (String password) {},
                  showVisibilityIcon: true,
                  fieldIndex: 2,
                  prefixIcon: const Icon(Icons.lock),
                  controller: confirmPasswordController,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hintText: "Código",
                  validationFunction: passwordValidator,
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

                /// [Create Account] Button
                MaterialButton(
                  height: 40,
                  minWidth: double.infinity,
                  onPressed: signUserUp,
                  color: const Color(0XFFBA704F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: const Text(
                    "Registrarse",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya está registrado?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Inicie ahora',
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
          "Crea una cuenta",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Por favor genere una contraseña segura que cumpla con los siguientes criterios.",
          style: TextStyle(
              fontSize: 16, height: 1.5, color: Color.fromARGB(255, 0, 0, 0)),
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
                  : Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
              borderRadius: BorderRadius.circular(50)),
          child: const Center(
            child: Icon(
              Icons.check,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 15,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
