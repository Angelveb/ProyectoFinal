import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  final User currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: const Offset(0, 0.2),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'Una ',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'comunidad,\n',
                        style: TextStyle(
                          color: Color(0xFF00BFA6),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'en la palma de tu mano',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'assets/welcoming.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Row(
                  children: [
                    const SizedBox(width: 280),
                    SlideTransition(
                    position: _offsetAnimation,
                    child: const Icon(Icons.face, color: Color.fromARGB(255, 0, 0, 0))
                  ),
                  ],
                ),
                const SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'Bienvenido a nuestro espacio informativo, donde te mantendremos al tanto de todo lo relevante. Aquí, encontrarás anuncios cruciales de la administración a la ',
                      ),
                      TextSpan(
                        text: 'izquierda',
                        style: TextStyle(color: Color(0xFFCA8A40),
                        fontWeight: FontWeight.bold)
                        
                      ),
                      TextSpan(
                        text: ' y anuncios de la comunidad a la',
                      ),
                      TextSpan(
                        text: ' derecha.',
                        style: TextStyle(color: Color(0xFF8A352A),
                        fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text: ' \nSi deseas publicar un anuncio, espera la aprobación de la administración para que se vea en el muro de la comunidad. ¡Estamos aquí para mantener nuestra comunidad ',
                      ),
                      TextSpan(
                        text: 'informada ',
                        style: TextStyle(
                        color: Color(0xFF00BFA6),
                        ),
                      ),
                      TextSpan(
                        text: 'y ',
                        style: TextStyle(
                        ),
                      ),
                      TextSpan(
                        text: 'conectada',
                        style: TextStyle(
                          color: Color(0xFF00BFA6),
                        ),
                      ),
                      TextSpan(
                        text: '!',
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

}
