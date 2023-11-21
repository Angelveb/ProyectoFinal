import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:proyecto_v2/presentation/pages/assembly/views/question_page.dart';

class LoadPowerPage extends StatefulWidget {
  const LoadPowerPage({Key? key}) : super(key: key);

  @override
  _LoadPowerPageState createState() => _LoadPowerPageState();
}

class _LoadPowerPageState extends State<LoadPowerPage> {
  String? _filePath;
  bool _loading = false;
  int _powerCount = 0; // Nuevo contador para los nombres secuenciales

  Future<void> _pickAndLoadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    }
  }

  Future<void> _showLoadPowerDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Cargar poder'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Por favor carga el archivo del poder que te envió el propietario',
                  ),
                  const SizedBox(height: 20),
                  if (_loading)
                    const CircularProgressIndicator()
                  else
                    IconButton(
                      icon: const Icon(Icons.file_upload),
                      iconSize: 64,
                      onPressed: () async {
                        await _pickAndLoadFile();
                        Navigator.pop(context);
                        if (_filePath != null) {
                          await _uploadToStorageAndFirestore();
                        }
                      },
                    ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el cuadro de diálogo
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _uploadToStorageAndFirestore() async {
    setState(() {
      _loading = true;
    });

    firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('poderes');

    try {
      await storageRef.child('$_filePath').putFile(File(_filePath!));

      String downloadURL =
          await storageRef.child('$_filePath').getDownloadURL();

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference poderesCollection = firestore.collection('Poderes');

      // Utilizamos el contador para generar nombres secuenciales
      _powerCount++;
      String nombrePoder = 'Poder$_powerCount';

      await poderesCollection.add({
        'Nombre': nombrePoder,
        'ArchivoURL': downloadURL,
        'FechaCarga': FieldValue.serverTimestamp(),
        'UsuarioId': 'Id_del_usuario_que_cargó',
      });

      // Mostrar un cuadro de diálogo para indicar que el poder se cargó correctamente
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Éxito'),
            content: const Text('¡Poder cargado con éxito!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el cuadro de diálogo
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuestionsPage(),
                    ),
                  );
                },
                child: const Text('Continuar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error al agregar documento a la colección "Poderes": $e');
      // Mostrar un cuadro de diálogo indicando que hubo un error al cargar el poder
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Error al cargar el poder'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el cuadro de diálogo
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargar Poder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Deseas cargar el poder?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showLoadPowerDialog();
              },
              child: const Text('Sí, cargar poder'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Regresar a la pantalla anterior
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuestionsPage(),
                  ),
                );
              },
              child: const Text('No, continuar'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
