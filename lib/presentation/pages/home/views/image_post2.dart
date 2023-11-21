import 'dart:io';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_v2/services/select_image.dart';
import 'package:proyecto_v2/services/upload_image.dart';

class ImageUploadDialog extends StatefulWidget {
  final Function(File) onImageSelected;

  const ImageUploadDialog({super.key, required this.onImageSelected});

  @override
  _ImageUploadDialogState createState() => _ImageUploadDialogState();
}

class _ImageUploadDialogState extends State<ImageUploadDialog> {
  XFile? pickedImage;

  Future<void> _getImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      pickedImage = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Seleccionar imagen"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () async {
              await _getImage(ImageSource.gallery);
            },
            child: const Text("Seleccionar de la galería"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _getImage(ImageSource.camera);
            },
            child: const Text("Tomar foto"),
          ),
          if (pickedImage != null)
            Image.file(File(pickedImage!.path),
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ElevatedButton(
            onPressed: () {
              if (pickedImage != null) {
                widget.onImageSelected(File(pickedImage!.path));
                Navigator.of(context).pop(); // Cerrar el diálogo después de seleccionar la imagen
              }
            },
            child: const Text("Subir imagen"),
          ),
        ],
      ),
    );
  }
}

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
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Error al subir la imagen',
        btnOkOnPress: () {
          setState(() {});
        },
        btnOkColor: Colors.grey,
      ).show();
    }
  }

  Future<void> handleImageUpload() async {
    if (imageToUpload == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Selecciona una imagen antes de subirla',
        btnOkOnPress: () {
          setState(() {});
        },
      ).show();
      return;
    }

    final uploaded = await uploadImage(imageToUpload!);

    if (uploaded) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
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
                maxWidth: 500, maxHeight: 500),
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
                child: const Center(
                  child: Text(
                    'No has cargado ninguna imagen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
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
