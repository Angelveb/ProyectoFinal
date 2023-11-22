import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_v2/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  String defaultImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/proyectov2-d9bc1.appspot.com/o/profile_pictures%2FperfilPredeterminado.png?alt=media&token=62eccc35-045b-4e85-80d9-9157becb5e64';

  TextEditingController torreController = TextEditingController();
  TextEditingController apartamentoController = TextEditingController();

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Editar $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Ingresar nuevo $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  Future<void> pickAndUploadImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("profile_pictures/${currentUser.uid}.jpg");
      final uploadTask = storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() async {

        final imageUrl = await storageRef.getDownloadURL();

        await usersCollection
            .doc(currentUser.email)
            .update({"profile_picture": imageUrl});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data?.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Stack(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.network(
                                userData['profile_picture'] ?? defaultImageUrl,
                                width: 2 * 120,
                                height: 2 * 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 95,
                        top: 150,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            iconSize: 23,
                            icon: const Icon(Icons.camera_alt_rounded),
                            color: Colors.blue,
                            onPressed: () {
                              pickAndUploadImage();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "Mis Detalles",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                MyTextBox(
                  icon: Icons.account_circle,
                  text: userData['nombre'],
                  sectionName: 'Nombre',
                  onPressed: () => editField('nombre'),
                ),
                MyTextBox(
                  icon: Icons.apartment_rounded,
                  text: userData['torre'] ?? "Torre no especificada",
                  sectionName: 'Torre',
                  onPressed: () => editField('torre'),
                ),
                MyTextBox(
                  icon: Icons.door_back_door,
                  text: userData['apartamento'] ?? "Apartamento no especificado",
                  sectionName: 'Apartamento',
                  onPressed: () => editField('apartamento'),
                ),
                
                MyTextBox(
                  icon: Icons.settings_accessibility,
                  text: currentUser.email == "tu_correo_electronico"
                      ? (userData['mi_rol_especial'] as String?) ??
                          "Mi Rool Especial no especificado"
                      : (userData['rool'] as String?) ?? "Rool no especificado",
                  sectionName: 'Rol',
                  onPressed: () async {
                    if (currentUser.email == 'admin@gmail.com') {
                      String? newValue = await showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('Eres administrador'),
                        ),
                      );

                      if (newValue != null) {
                        await usersCollection
                            .doc(currentUser.email)
                            .update({'rol_admin': newValue});
                      }
                    } else {
                      String? newValue = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Elige tu rol'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('Propietario'),
                                onTap: () {
                                  Navigator.pop(context, "Propietario");
                                },
                              ),
                              ListTile(
                                title: const Text('Arrendatario'),
                                onTap: () {
                                  Navigator.pop(context, "Arrendatario");
                                },
                              ),
                            ],
                          ),
                        ),
                      );

                      if (newValue != null) {
                        await usersCollection
                            .doc(currentUser.email)
                            .update({'rool': newValue});
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
                
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
