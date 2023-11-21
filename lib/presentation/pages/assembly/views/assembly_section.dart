import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_v2/presentation/pages/assembly/assembly_page.dart';
import 'package:proyecto_v2/presentation/pages/assembly/views/assembly_page_admin.dart';
import 'package:proyecto_v2/presentation/pages/assembly/views/question_page.dart';

class AsambleasSection extends StatelessWidget {
  AsambleasSection({super.key});

  // Usuario
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<bool> hasScheduledAssembly() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('asambleas').get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Asambleas Comunitarias'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/assembly.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const Text(
                'Bienvenido a la Sección de Asambleas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Explora:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Detalles Detallados: Sumérgete en cada asamblea con detalles claros y concisos. Desde el título inspirador hasta el orden del día completo, encontrarás todo lo que necesitas saber en un solo vistazo.',
              ),
              const SizedBox(height: 10),
              const Text(
                'Fecha Importante: Mantente al tanto de las fechas cruciales. Nuestra app te informa sobre cuándo y dónde suceden las próximas reuniones para que nunca te pierdas un momento significativo.',
              ),
              const SizedBox(height: 10),
              const Text(
                'Orden del Día: Descubre los temas que darán forma a nuestras discusiones. El orden del día te proporciona una visión general estructurada de lo que puedes esperar en cada asamblea.',
              ),
              const SizedBox(height: 20),
              const Text(
                'Participa:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Puedes contrubuir con votos en las decisiones que se vayan a tomar.'),
              /* const Text(
                'Conecta con la Comunidad: Comenta, comparte tus ideas y participa en las conversaciones que importan. La sección de comentarios te permite interactuar con otros miembros de la comunidad y compartir tus pensamientos.',
              ),
              const SizedBox(height: 10),
              const Text(
                'Publica Anuncios: ¿Tienes algo importante que compartir? Si eres no un administrador, puedes publicar anuncios que serán revisados y compartidos con la comunidad después de la aprobación.',
              ), */
              const SizedBox(height: 20),
              const Text(
                'Mantente Informado:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Votaciones en Tiempo Real: Podras recibir actualizaciones instantáneas sobre los votos realizados en las asambleas, personas unidas a la asamblea y quienes votaron. Estamos aquí para mantenerte informado y conectado.',
              ),
              const SizedBox(height: 20),
              const Text(
                'Cuando el administrador de tu conjunto haya programado una asamblea, podrás visualizar el boton para unirte',
                style: TextStyle(
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: FutureBuilder<bool>(
                  future: hasScheduledAssembly(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      bool hasAssembly = snapshot.data ?? false;

                      if (hasAssembly) {
                        return ElevatedButton(
                          onPressed: () {
                            // pop menu drawer
                            Navigator.pop(context);

                            // got to profile page
                            if (currentUser.email == 'admin@gmail.com') {
                              // Si el usuario tiene el correo electrónico específico
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const QuestionsPage(),
                                ),
                              );
                            } else {
                              // Si el usuario tiene cualquier otro correo electrónico
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AssemblyPage(),
                                ),
                              );
                            }
                          },
                          child: const Text('Unirse a la Asamblea'),
                        );
                      } else {
                        // Solo mostrar el botón si el usuario es admin@gmail.com
                        return currentUser.email == 'admin@gmail.com'
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AssemblyAdminPage(),
                                    ),
                                  );
                                },
                                child: const Text('Programar una Asamblea'),
                              )
                            : const SizedBox(); // Si no es admin, devuelve un contenedor vacío
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
