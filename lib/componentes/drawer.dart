import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_v2/componentes/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onClubTap;
  final void Function()? onWalletTap;
  final void Function()? onAssemblyTap;
  final void Function()? onPQRSTap;
  final void Function()? onSignOut;

  MyDrawer({
    super.key,
    this.onProfileTap,
    this.onSignOut,
    this.onWalletTap,
    this.onPQRSTap,
    this.onClubTap,
    this.onAssemblyTap,
  });

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  final String defaultImageUrl = 'https://firebasestorage.googleapis.com/v0/b/proyectov2-d9bc1.appspot.com/o/profile_pictures%2FperfilPredeterminado.png?alt=media&token=62eccc35-045b-4e85-80d9-9157becb5e64';

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
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          final userData = snapshot.data?.data() as Map<String, dynamic>;
          
        return Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                     UserAccountsDrawerHeader(
                      accountName: Text(userData['nombre'],
                          style: const TextStyle(color: Color(0xFFFFFFFF))),
                      accountEmail: Text(
                        currentUser.email!,
                        style: const TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                      currentAccountPicture: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userData['profile_picture'] ?? defaultImageUrl),
                            radius: 36, // Ajusta el tamaño de la imagen de perfil
                          ),
                        ],
                      ),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/portada.jpg'),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                      margin: EdgeInsets.zero,
                    ),
                      
                        Positioned(
                          top: 125,
                          right: 10,
                          child: IconButton(
                            icon: Icon(
                              currentUser.email == 'admin@gmail.com'
                                  ? Icons.stars_rounded
                                  : Icons.person_3,
                              color: currentUser.email == 'admin@gmail.com'
                                  ? Colors.amber
                                  : Colors.white,
                              size: 30,
                            ),
                            onPressed: () {},
                          ),
                        ),
                    ]
                  ),
        
                  const SizedBox(height: 10),

        
                  //home list tile
                  MyListTile(
                    icon: Icons.apartment_rounded,
                    text: 'Inicio',
                    onTap: () => Navigator.pop(context),
                  ),
        
                  MyListTile(
                    icon: Icons.person,
                    text: 'Perfil',
                    onTap: onProfileTap,
                  ),
        
                  MyListTile(
                    icon: Icons.sports_gymnastics_rounded,
                    text: 'Club House',
                    onTap: onClubTap,
                  ),
        
                  MyListTile(
                    icon: Icons.incomplete_circle_rounded,
                    text: 'Asambleas',
                    onTap: onAssemblyTap,
                  ),
        
                  MyListTile(
                    icon: Icons.wallet,
                    text: 'Archivos',
                    onTap: onWalletTap,
                  ),
        
                  MyListTile(
                    icon: Icons.question_answer_outlined,
                    text: 'PQRS',
                    onTap: onPQRSTap,
                  ),
        
                  const SizedBox(
                    width: 230, // Establece el ancho del Container al máximo disponible
                    child: Divider(),
                  )
                ],
              ),
        
              //logout list tile
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: MyListTile(
                      icon: Icons.logout,
                      text: 'S A L I R',
                      onTap: onSignOut,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
      }    
    );
  }
}
