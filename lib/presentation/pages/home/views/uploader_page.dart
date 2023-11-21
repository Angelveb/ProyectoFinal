import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class UploaderPage extends StatefulWidget {
  const UploaderPage({super.key});

  @override
  State<UploaderPage> createState() => _UploaderPageState();
}

class _UploaderPageState extends State<UploaderPage> {
  int currentIndex = 0;
  int likeCount = 0;
  int dislikeCount = 0;

  Future<void> uploadFilesDesktop() async {
    final images = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (images == null) {
      return;
    }

    for (final image in images.files) {
      final name = image.name;

      final ref = FirebaseStorage.instance
          .ref('post/${name + DateTime.now().toString()}');

      final data = image.bytes;
      await ref.putData(data!);
    }

    setState(() {});
  }

  Future<bool> showConfirmDialog(String imagePath) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Anuncio"),
          content: Image.file(File(imagePath)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Usuario cancela la subida
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Usuario confirma la subida
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showErrorDialog() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Error',
      desc: 'Ocurrió un error al seleccionar/cargar la imagen',
      btnOkText: 'OK',
      btnOkOnPress: () {},
    ).show();
  }

  Future<void> uploadFiles() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return uploadFilesDesktop();
    }

    final images = await ImagePicker().pickMultiImage();

    if (images.isEmpty) {
      // Muestra el diálogo de error si no se seleccionaron imágenes
      showErrorDialog();
      return;
    }

    for (final image in images) {
      final ref =
          FirebaseStorage.instance.ref('post/${DateTime.now().toString()}');
      final data = await image.readAsBytes();

      // Mostrar el diálogo de confirmación antes de subir la imagen
      bool confirmUpload = await showConfirmDialog(image.path);
      if (!confirmUpload) {
        continue;
      }

      // Subir la imagen sin aprobación
      await ref.putData(
          data, SettableMetadata(customMetadata: {'approved': '1'}));
    }

    showUploadDialog(); // Mostrar diálogo de éxito después de la subida
    setState(() {});
  }

  void showUploadDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Exíto',
      desc: 'El anuncio se subió correctamente',
      btnOkText: 'OK',
      btnOkOnPress: () {},
    ).show();
  }

  Future<List<Reference>> loadImages() async {
    final ref = FirebaseStorage.instance.ref('post');
    final result = await ref.listAll();

    List<Reference> images = result.items;

    // Ordena la lista de referencias por fecha de creación en orden descendente
    images.sort((a, b) => b.fullPath.compareTo(a.fullPath));

    return images;
  }

  String calculateTimeDifference(DateTime uploadTime) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(uploadTime);

    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'Hace un momento';
    }
  }

  Future<void> deleteImage(Reference imageRef) async {
    try {
      // Elimina la imagen de Firebase Storage
      await imageRef.delete();

      // Vuelve a cargar la lista de imágenes después de la eliminación
      setState(() {});
    } catch (e) {
      print('Error al eliminar la imagen: $e');
      // Puedes mostrar un mensaje de error al usuario si la eliminación falla
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadImages(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Reference> images = snapshot.data as List<Reference>;
              return ListView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: images[index].getMetadata(),
                    builder: (context, snapshotMetadata) {
                      if (snapshotMetadata.hasData) {
                        final metadata = snapshotMetadata.data as FullMetadata;
                        final uploadTime =
                            metadata.timeCreated ?? DateTime.now();
                        final formattedTime =
                            calculateTimeDifference(uploadTime);

                        return FutureBuilder(
                          future: images[index].getDownloadURL(),
                          builder: (context, snapshotUrl) {
                            if (snapshotUrl.hasData) {
                              final url = snapshotUrl.data as String;

                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: Image.asset(
                                                'assets/perfilPredeterminado.png',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 9),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Administración',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(formattedTime),
                                              ],
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            // Verifica si el usuario está autenticado y es el administrador
                                            if (currentUser.email ==
                                                "admin@gmail.com") {
                                              // Muestra un cuadro de diálogo de confirmación antes de eliminar la imagen
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Eliminar Imagen"),
                                                    content: const Text(
                                                        "¿Estás seguro de que quieres eliminar esta imagen?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Cierra el cuadro de diálogo
                                                        },
                                                        child: const Text(
                                                            "Cancelar"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          deleteImage(
                                                              images[index]);
                                                          Navigator.pop(
                                                              context); // Cierra el cuadro de diálogo después de la eliminación
                                                        },
                                                        child: const Text(
                                                            "Eliminar"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              // Muestra un mensaje diferente si el usuario no está autenticado como administrador
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Acceso Denegado"),
                                                    content: const Text(
                                                        "Solo el administrador puede realizar esta acción."),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Cierra el cuadro de diálogo
                                                        },
                                                        child: const Text("OK"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoViewGallery.builder(
                                            itemCount: 1,
                                            builder: (context, index) {
                                              return PhotoViewGalleryPageOptions(
                                                imageProvider:
                                                    NetworkImage(url),
                                                minScale: PhotoViewComputedScale
                                                    .contained,
                                                maxScale: PhotoViewComputedScale
                                                        .covered *
                                                    2,
                                              );
                                            },
                                          ),
                                        ));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 20, bottom: 50),
                                        width: 320,
                                        height: 330,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(url),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              );
                            } else if (snapshotUrl.hasError) {
                              return const Text('Error loading image');
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                },
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: currentUser.email == "admin@gmail.com"
          ? FloatingActionButton(
              onPressed: uploadFiles,
              tooltip: 'Upload',
              child: const Icon(Icons.upload),
            )
          : null,
    );
  }
}
