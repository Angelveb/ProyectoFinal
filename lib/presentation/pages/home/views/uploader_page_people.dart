import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class UploaderPage2 extends StatefulWidget {
  const UploaderPage2({super.key});

  @override
  State<UploaderPage2> createState() => _UploaderPage2State();
}

class _UploaderPage2State extends State<UploaderPage2> {
  late User currentUser;
  bool showAwesomeDialog = false; 

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
  }

  Future<void> uploadFilesDesktop() async {
    final images = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (images == null) {
      return;
    }

    for (final image in images.files) {
      final name = image.name;

      final ref = FirebaseStorage.instance.ref('postPeople/${name + DateTime.now().toString()}');
      final data = image.bytes;
      await ref.putData(data!, SettableMetadata(customMetadata: {'approved': '0'}));
    }

    setState(() {});
  }

  Future<void> showErrorDialog() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Error',
      desc: 'Ocurrió un error al seleccionar/cargar la imagen',
      btnOkText: 'OK',
      btnOkColor: Colors.grey,
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
    final ref = FirebaseStorage.instance.ref('postPeople/${DateTime.now().toString()}');
    final data = await image.readAsBytes();

    // Verificar si el usuario es administrador
    if (currentUser.email == "admin@gmail.com") {
      // Si es administrador, establecer 'approved' en '1'
      await ref.putData(data, SettableMetadata(customMetadata: {'approved': '1'}));
    } else {
      // Si no es administrador, mostrar el diálogo de confirmación
      bool confirmUpload = await showConfirmDialog(image.path);
      if (!confirmUpload) {
        continue;
      }

      // Subir la imagen con 'approved' en '0'
      await ref.putData(data, SettableMetadata(customMetadata: {'approved': '0'}));

      // Actualizar la variable para mostrar el AwesomeDialog
      showAwesomeDialog = true;
    }
  }

  // Muestra el AwesomeDialog solo si la variable es true
  if (showAwesomeDialog) {
    showUploadDialog();
    showAwesomeDialog = false; // Restablece el valor para la próxima vez
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

  void showUploadDialog() {
  // Verifica si el usuario NO está autenticado como administrador
  if (currentUser.email != "admin@gmail.com") {
    // Muestra el AwesomeDialog y el botón de aprobar solo si el usuario NO es administrador
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: '¡Éxito!',
      desc: 'La imagen ha sido subida y está pendiente de aprobación por parte de la administración.',
      btnOkText: 'OK',
      btnOkOnPress: () {},
    ).show();
  }
  // No muestra nada si el usuario es administrador
}


  Future<List<Reference>> loadImages() async {
    final ref = FirebaseStorage.instance.ref('postPeople');
    final result = await ref.listAll();

    List<Reference> images = result.items;

    images = await getImagesForAdmin(images);

    images.sort((a, b) => b.fullPath.compareTo(a.fullPath));

    return images;
  }

  Future<List<Reference>> getImagesForAdmin(List<Reference> images) async {
    if (currentUser.email == "admin@gmail.com") {
      return images;
    } else {
      List<Reference> approvedImages = [];
      for (final image in images) {
        final metadata = await image.getMetadata();
        if (metadata.customMetadata != null && metadata.customMetadata!['approved'] == '1') {
          approvedImages.add(image);
        }
      }
      return approvedImages;
    }
  }

  Future<void> approveImage(Reference imageRef) async {
    try {
      await imageRef.updateMetadata(SettableMetadata(customMetadata: {'approved': '1'}));
      setState(() {});
    } catch (e) {
      print('Error al aprobar la imagen: $e');
    }
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
      await imageRef.delete();
      setState(() {});
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Center(
          child: FutureBuilder(
            future: loadImages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Reference> allImages = snapshot.data as List<Reference>;

                return ListView.builder(
                  itemCount: allImages.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: allImages[index].getMetadata(),
                      builder: (context, snapshotMetadata) {
                        if (snapshotMetadata.hasData) {
                          final metadata = snapshotMetadata.data as FullMetadata;

                          final uploadTime = metadata.timeCreated ?? DateTime.now();
                          final formattedTime = calculateTimeDifference(uploadTime);

                          return FutureBuilder(
                            future: allImages[index].getDownloadURL(),
                            builder: (context, snapshotUrl) {
                              if (snapshotUrl.hasData) {
                                final url = snapshotUrl.data as String;

                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(40),
                                                child: Image.asset(
                                                  'assets/ar8.png',
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 9),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Comunidad',
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
                                             if (currentUser.email == "admin@gmail.com") {
                                              // Muestra un cuadro de diálogo de confirmación antes de eliminar la imagen
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Eliminar Imagen"),
                                                    content: const Text("¿Estás seguro de que quieres eliminar esta imagen?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context); // Cierra el cuadro de diálogo
                                                        },
                                                        child: const Text("Cancelar"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          deleteImage(allImages[index]);
                                                          Navigator.pop(context); // Cierra el cuadro de diálogo después de la eliminación
                                                        },
                                                        child: const Text("Eliminar"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              // Muestra un mensaje diferente si el usuario no está autenticado como administrador
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Acceso Denegado"),
                                                    content: const Text("Solo el administrador puede realizar esta acción."),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context); // Cierra el cuadro de diálogo
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
                                          if (currentUser.email == "admin@gmail.com" &&
                                              metadata.customMetadata!['approved'] == '0')
                                            ElevatedButton(
                                              onPressed: () {
                                                approveImage(allImages[index]);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                textStyle: const TextStyle(fontSize: 12),
                                                minimumSize: const Size(0, 40),
                                                maximumSize: const Size(100, 40),
                                              ),
                                              child: const Text("Aprobar"),
                                            ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => PhotoViewGallery.builder(
                                              itemCount: 1,
                                              builder: (context, index) {
                                                return PhotoViewGalleryPageOptions(
                                                  imageProvider: NetworkImage(url),
                                                  minScale: PhotoViewComputedScale.contained,
                                                  maxScale: PhotoViewComputedScale.covered * 2,
                                                );
                                              },
                                            ),
                                          ));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10, left: 20, bottom: 50),
                                          width: 320,
                                          height: 330,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(url),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(16),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadFiles,
        tooltip: 'Upload',
        child: const Icon(Icons.upload),
      ),
    );
  }
}
