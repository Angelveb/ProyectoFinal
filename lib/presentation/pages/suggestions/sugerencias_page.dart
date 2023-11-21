import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_v2/componentes/wall_post.dart';
import 'package:proyecto_v2/helper/helper_methods.dart';

class SugerenciasPage extends StatefulWidget {
  const SugerenciasPage({super.key});

  @override
  State<SugerenciasPage> createState() => _SugerenciasPageState();
}

class _SugerenciasPageState extends State<SugerenciasPage> {
  // Usuario
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Controlador texto
  final textController = TextEditingController();

  // Metodo de cierre de sesion

  // Metodo para publicar
  void postMessage() {
    // Only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": currentUser.email,
        "Message": textController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }

    // clear the textField
    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sugerencias',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black, // Cambia el color del icono a blanco
              ),
              onPressed: () {
                Navigator.pop(context); // Abre el cajón de navegación
              },
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // El muro
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 22),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Conecta con la Comunidad: Comenta, comparte tus ideas y participa en las conversaciones que importan.',
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: true,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // obtener el mensage
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post["Likes"] ?? []),
                          time: formatDate(post["TimeStamp"]),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // Publicar mensaje
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // TextField
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe cualquier cosa...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                  // Boton para postear
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.send_rounded),
                      color: const Color(0xFF592a2f),
                    ),
                  ),
                ],
              ),
            ),
            // Logged in as
            Text(
              "Enlazado con: ${currentUser.email!}",
              style: const TextStyle(color: Color(0xFF592a2f)),
            ),

            const SizedBox(height: 13),
          ],
        ),
      ),
    );
  }
}
