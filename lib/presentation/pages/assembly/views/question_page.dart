import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_v2/presentation/pages/assembly/pie_chart.dart';
import 'package:proyecto_v2/presentation/pages/assembly/views/assembly_page_detail.dart';
import 'package:proyecto_v2/presentation/pages/assembly/views/download_page.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final TextEditingController preguntaController = TextEditingController();
  final CollectionReference preguntasCollection =
      FirebaseFirestore.instance.collection('preguntas');
  String preguntaActual = ' ';

  void verInfoAsamblea() {

    // Navega a la nueva pantalla con detalles de la asamblea
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssemblyDetailPage(),
      ),
    );
  }

  void enviarPregunta() {
    String pregunta = preguntaController.text;

    if (pregunta.isNotEmpty) {
      preguntasCollection.add({
        'pregunta': pregunta,
        'fecha': FieldValue.serverTimestamp(),
      });

      setState(() {
        preguntaActual = pregunta; // Actualiza la pregunta actual
      });

      preguntaController.clear();
    }
  }

  void eliminarPregunta(String preguntaId) async {
    // Obtener información del usuario autenticado
    final currentUser = FirebaseAuth.instance.currentUser;

    // Verificar si el usuario es el administrador
    if (currentUser != null && currentUser.email == "admin@gmail.com") {
      // Si es administrador, mostrar directamente el cuadro de diálogo de confirmación
      _showConfirmationDialog(preguntaId);
    } else {
      // Mostrar un mensaje de acceso denegado
      _showAccessDeniedDialog();
    }
  }

  void _showConfirmationDialog(String preguntaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Pregunta'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar esta pregunta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el cuadro de diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Eliminar la pregunta y cerrar el cuadro de diálogo
                await preguntasCollection.doc(preguntaId).delete();
                Navigator.pop(context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showAccessDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Acceso Denegado"),
          content:
              const Text("Solo el administrador puede realizar esta acción."),
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

  void finalizarAsamblea() {
    // Obtener información del usuario autenticado
    final currentUser = FirebaseAuth.instance.currentUser;

    // Verificar si el usuario es el administrador
    if (currentUser != null && currentUser.email == "admin@gmail.com") {
      // Si es administrador, mostrar directamente el cuadro de diálogo de finalización
      showConfirmationDialogFinalizarAsamblea();
    } else {
      // Si no es administrador, mostrar un mensaje de acceso denegado
      _showAccessDeniedDialog();
    }
  }

  void showConfirmationDialogFinalizarAsamblea() {
    // Obtener información del usuario autenticado
    final currentUser = FirebaseAuth.instance.currentUser;

    // Verificar si el usuario es el administrador
    if (currentUser != null && currentUser.email == "admin@gmail.com") {
      // Si es administrador, mostrar directamente el cuadro de diálogo de finalización
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Finalizar Asamblea'),
            content: const Text(
                '¿Estás seguro de que quieres finalizar la asamblea?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el cuadro de diálogo
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  eliminarAsamblea();
                  print('Asamblea finalizada');

                  Navigator.pop(context); // Cierra el cuadro de diálogo
                },
                child: const Text('Finalizar'),
              ),
            ],
          );
        },
      );
    } else {
      // Si no es administrador, mostrar un mensaje de acceso denegado
      _showAccessDeniedDialog();
    }
  }

  void eliminarAsamblea() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Finalizar Asamblea'),
          content: const Text(
              '¿Estás seguro de que quieres finalizar la asamblea? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el cuadro de diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Eliminar la colección "asambleas" y cerrar el cuadro de diálogo
                await FirebaseFirestore.instance
                    .collection('asambleas')
                    .get()
                    .then((snapshot) {
                  for (DocumentSnapshot ds in snapshot.docs) {
                    ds.reference.delete();
                  }
                });
                Navigator.pop(context);
                // Puedes realizar otras acciones después de eliminar la asamblea si es necesario
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void goToOtraPantalla() {
    // Obtener información del usuario autenticado
    final currentUser = FirebaseAuth.instance.currentUser;

    // Verificar si el usuario es el administrador
    if (currentUser != null && currentUser.email == "admin@gmail.com") {
      // Si es administrador, navegar a otra pantalla
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DownloadPowerPage(),
        ),
      );
    } else {
      // Si no es administrador, mostrar un mensaje de acceso denegado
      _showAccessDeniedDialog();
    }
  }

  void mostrarTabla() {
    // Almacena el BuildContext fuera del bloque async
    BuildContext currentContext = context;

    // Obtener información del usuario autenticado
    final currentUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot usersSnapshot) {
      List<Map<String, dynamic>> users =
          usersSnapshot.docs.map((DocumentSnapshot doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      showDialog(
        context: currentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Tabla de Apartamentos'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Apartamento')),
                      DataColumn(label: Text('Estado')),
                    ],
                    rows: [
                      // Obtener información de usuarios y mostrarla en la tabla
                      for (var userData in users)
                        DataRow(
                          color: (currentUser != null &&
                                  currentUser.email == userData['correo'])
                              ? MaterialStateProperty.all<Color>(Colors.green)
                              : null,
                          cells: [
                            DataCell(Text(userData['apartamento'] ?? '')),
                            DataCell(
                              // Mostrar la X en rojo si el apartamento está vacío o si el usuario no está dentro de la aplicación
                              (userData['apartamento'] ==
                                          "Apartamento vacío.." ||
                                      currentUser == null)
                                  ? const Icon(Icons.clear, color: Colors.red)
                                  : const Icon(Icons.check,
                                      color: Colors
                                          .green), // Puedes ajustar según tus necesidades
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el cuadro de diálogo
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      print("Error al obtener la lista de usuarios: $error");
      // Manejar el error según tus necesidades
    });
  }

  bool isOnQuestionsPage() {
    // Lógica para verificar si el usuario está en la página QuestionsPage
    // Puedes ajustar esto según cómo estés manejando la navegación en tu aplicación.
    // Por ejemplo, puedes comparar la ruta actual con la ruta de QuestionsPage.
    // Aquí proporciono un ejemplo simple:
    return ModalRoute.of(context)?.settings.name == '/questions';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: showConfirmationDialogFinalizarAsamblea,
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: verInfoAsamblea,
          ),
          IconButton(
            icon: const Icon(Icons.table_chart), // Icono para mostrar la tabla
            onPressed: () {
              // Lógica para mostrar la tabla aquí
              mostrarTabla();
            },
          ),
          IconButton(
            icon: const Icon(Icons.document_scanner_rounded), // Nuevo ícono para la otra pantalla
            onPressed: goToOtraPantalla,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Asamblea en curso',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (currentUser == null || currentUser.email != "admin@gmail.com")
              const Text(
                'En esta sección, el administrador puede realizar preguntas que serán visualizadas en la lista a continuación. Toca alguna de ellas para ver los resultados de la pregunta.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )
            else
              Column(
                children: [
                  TextFormField(
                    controller: preguntaController,
                    decoration: const InputDecoration(
                      labelText: 'Escribe tu pregunta',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      enviarPregunta();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionsDetailsPage(
                            pregunta: preguntaActual,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Enviar pregunta y ver resultados',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: preguntasCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No hay preguntas disponibles'),
                    );
                  }

                  var preguntas = snapshot.data!.docs;

                  List<Widget> preguntasWidgets = [];
                  for (int i = 0; i < preguntas.length; i++) {
                    var pregunta = preguntas[i];
                    var preguntaData = pregunta.data() as Map<String, dynamic>;
                    var preguntaText = preguntaData['pregunta'];

                    preguntasWidgets.add(
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionsDetailsPage(
                                pregunta: preguntaText,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              '${i + 1}. $preguntaText',
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                eliminarPregunta(pregunta.id);
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView(
                    children: preguntasWidgets,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionsDetailsPage extends StatelessWidget {
  final String pregunta;

  const QuestionsDetailsPage({super.key, required this.pregunta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Pregunta'),
      ),
      body: MyPieChart(pregunta: pregunta),
    );
  }
}
