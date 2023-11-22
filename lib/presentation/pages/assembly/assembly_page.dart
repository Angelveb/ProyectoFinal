import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_v2/components/assembly_box.dart';
import 'package:proyecto_v2/presentation/pages/assembly/views/assembly_init.dart';
import 'package:proyecto_v2/presentation/pages/assembly/views/assembly_section.dart';
import 'package:proyecto_v2/presentation/pages/assembly/views/load_doc_page.dart';
import 'package:proyecto_v2/presentation/pages/profile/profile_page.dart';

class AssemblyPage extends StatefulWidget {
  const AssemblyPage({super.key});

  @override
  State<AssemblyPage> createState() => _AssemblyPageState();
}

class _AssemblyPageState extends State<AssemblyPage> {
  late String assemblyTitle = ''; // Inicializa assemblyTitle aquí
  late String assemblyApartment = ''; // Inicializa assemblyTitle aquí
  late String assemblyDescription = ''; // Inicializa assemblyTitle aquí
  late String assemblyName = ''; // Inicializa assemblyTitle aquí
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    // Llama a la función para obtener el título al inicio
    _fetchAssemblyTitle();
    _fetchApartment();
  }

  void _showProfileAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aviso'),
          content: const Text('Por favor, ingrese la torre y apartamento en la sección de perfil y luego vuelva a unirse a la asamblea'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                goToProfilePage(); // Agrega la función goToProfilePage para redirigir al usuario a la sección de perfil
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _fetchAssemblyTitle() async {
    try {
      // Accede a Firestore y obtén el último documento de la colección "asambleas"
      var querySnapshot = await FirebaseFirestore.instance.collection('asambleas').orderBy('date', descending: true).limit(1).get();
      
      // Asegúrate de que hay al menos un documento en la colección
      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        setState(() {
          assemblyTitle = document['title'];
          assemblyDescription = document['description'];
        });
      }
    } catch (e) {
      print('Error al obtener el título: $e');
    }
  }

  void nameFuntion() async {
    try {
      // Accede a Firestore y obtén el título de la colección "asambleas"
      var document = await FirebaseFirestore.instance.collection('Users').doc().get();
      // Asegúrate de que el documento existe y contiene un campo 'title'
      if (document.exists) {
        setState(() {
          assemblyName = document['nsombre'];
        });
      }
    } catch (e) {
      print('Error al obtener el título: $e');
    }
  }

  void _fetchApartment() async {
  try {
    // Accede a Firestore y obtén el título de la colección "Users"
    var document = await FirebaseFirestore.instance.collection('Users').doc(currentUser.uid).get();
    // Asegúrate de que el documento existe y contiene un campo 'apartamento'
    if (document.exists) {
      setState(() {
        assemblyApartment = document['apartamento'];
      });
    }
  } catch (e) {
    print('Error al obtener el número del apartamento: $e');
  }
}

  void goToPieChartPage() {
    // Verifica si el usuario tiene la información de torre y apartamento
    if (assemblyApartment.isEmpty || userData['torre'].isEmpty) {
      _showProfileAlert();
    } else {
      // pop menu drawer
      Navigator.pop(context);

      // got to profile page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AssemblyInitPage(),
        ),
      );
    }
  }

  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(), // Reemplaza YourProfilePage con el nombre correcto de tu página de perfil
      ),
    );
  }

  void goToQuestionPage() {
    //pop menu drawer
    Navigator.pop(context);

    // got to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  const LoadPowerPage(),
      ),
    );
  }

  void goToAsambleasSection() {
    //pop menu drawer
    Navigator.pop(context);

    // Regresar a la pantalla AsambleasSection
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssembliesSection(),
      ),
    );
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
        
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: const Text('Asamblea'),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: goToAsambleasSection,
              ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  assemblyTitle.isNotEmpty ? assemblyTitle : 'Cargando...', // Muestra "Cargando..." si el título aún no se ha cargado
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  assemblyDescription.isNotEmpty ? assemblyDescription : 'Cargando...', // Muestra "Cargando..." si el título aún no se ha cargado
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                CustomTextBox(
                  controller: TextEditingController(),
                  noButtonText: '',
                  yesButtonText: '',
                  onNoPressed: goToPieChartPage,
                  onYesPressed: goToQuestionPage,
                  title: '¡Bienvenido, !',
                  text: '¿Vas a representar el apartamento ${userData['apartamento']} de la torre ${userData['torre']} en esta asamblea ?',
                  subtitle: '',
                ),
              ],
            ),
          ),
        );
      }else if (snapshot.hasError) {
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
