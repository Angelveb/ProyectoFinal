import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_v2/services/select_image.dart';
import 'package:proyecto_v2/services/upload_image.dart';

class ImagePost extends StatefulWidget {
  const ImagePost({super.key});

  @override
  ImagePostState createState() => ImagePostState();
}

class ImagePostState extends State<ImagePost> {
  File? imageToUpload;

  Future<void> showSnackBarMessage(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> handleImageSelection() async {
    final imagen = await getImage();
    if (imagen != null) {
      setState(() {
        imageToUpload = File(imagen.path);
      });
    } else {
      // ignore: use_build_context_synchronously
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error, // Tipo de diálogo de éxito
        animType: AnimType.bottomSlide, // Tipo de animación
        title: 'Error al subir la imagen',
        btnOkOnPress: () {
          setState(() {});
        },
        btnOkColor: Colors.grey
      ).show();
    }
  }

  Future<void> handleImageUpload() async {
    if (imageToUpload == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning, // Tipo de diálogo de éxito
        animType: AnimType.bottomSlide, // Tipo de animación
        title: 'Selecciona una imagen antes de subirla',
        btnOkOnPress: () {
          setState(() {});
        },
      ).show();
      return;
    }

    final uploaded = await uploadImage(imageToUpload!);

    if (uploaded) {
      // showSnackBarMessage("Imagen subida correctamente");
      
      // ignore: use_build_context_synchronously
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success, // Tipo de diálogo de éxito
        animType: AnimType.bottomSlide, // Tipo de animación
        title: 'Imagen subida correctamente',
        btnOkOnPress: () {
          setState(() {});
        },
      ).show();

    } else {
      showSnackBarMessage("Error al subir la imagen");
    }
  }

  Widget buildImageWidget() {
    return imageToUpload != null
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: const BoxConstraints(
                  maxWidth: 500, maxHeight: 500), // Restricciones de tamaño
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.file(
                  imageToUpload!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: handleImageSelection,
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: const Color(0xFFA18888)
                ),
                child: const Center(child: Text('No has cargado ninguna imagen', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(child: buildImageWidget()),
          ElevatedButton(
            onPressed: handleImageSelection,
            child: const Text('Seleccionar imagen'),
          ),
          ElevatedButton(
            onPressed: handleImageUpload,
            child: const Text('Subir'),
          ),
        ],
      ),
    );
  }
}
