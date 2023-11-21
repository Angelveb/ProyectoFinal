import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MyPieChart extends StatefulWidget {
  final String pregunta;

  const MyPieChart({super.key, required this.pregunta});

  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {

  bool showVoters = false;
  late Stream<QuerySnapshot>? respuestasStream;
  final CollectionReference respuestasCollection =
      FirebaseFirestore.instance.collection('respuestas');
  final User? user = FirebaseAuth.instance.currentUser;

  int votosSi = 0;
  int votosNo = 0;
  bool yaVoto = false;

  

  @override
  void initState() {
    super.initState();
    // Filtra las respuestas por la pregunta actual y el usuario actual
    respuestasStream = respuestasCollection
        .where('pregunta', isEqualTo: widget.pregunta)
        .snapshots();
  }

  void registrarRespuesta(String respuesta) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // Manejar el caso en el que el usuario no esté autenticado
      return;
    }

    // Verifica si el usuario ya ha votado
    final querySnapshot = await respuestasCollection
        .where('userId', isEqualTo: currentUser.uid)
        .where('pregunta', isEqualTo: widget.pregunta)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // El usuario ya ha votado, muestra un mensaje indicando esto
      setState(() {
        yaVoto = true;
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Ya has votado en esta pregunta.",
        btnOkOnPress: () {},
      ).show();
    } else {
      // El usuario aún no ha votado, registra la respuesta
      await respuestasCollection.add({
        'userId': currentUser.uid,
        'respuesta': respuesta,
        'fecha': FieldValue.serverTimestamp(),
        'pregunta': widget.pregunta,
      });

      // Muestra el mensaje de éxito solo si el usuario no ha votado previamente
      if (!yaVoto) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "¡Tu voto fue registrado!",
          btnOkOnPress: () {},
        ).show();

        // Actualiza yaVoto después de mostrar el AwesomeDialog de éxito
        Future.delayed(Duration.zero, () {
          setState(() {
            yaVoto = true;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica si pregunta es nulo o está vacío antes de navegar a MyPieChart
    if (widget.pregunta.isEmpty) {
      // Utilizamos Navigator.pop para retroceder en lugar de Navigator.push
      return const Scaffold(
        body: Center(
          child: Text('No se ha generado una pregunta.'),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder(
        stream: respuestasStream,
        builder: (context, AsyncSnapshot<QuerySnapshot>? snapshot) {
          if (snapshot?.hasError == true) {
            return const Text('Error al cargar los datos');
          }

          if (snapshot?.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<DocumentSnapshot> documents = snapshot!.data!.docs;
          int oldVotosSi = votosSi;
          int oldVotosNo = votosNo;
          votosSi = 0;
          votosNo = 0;

          for (var document in documents) {
            if (document['respuesta'] == 'Si') {
              votosSi++;
            } else if (document['respuesta'] == 'No') {
              votosNo++;
            }
          }

          if (votosSi != oldVotosSi || votosNo != oldVotosNo) {
            // Llamar al método para actualizar la gráfica
            Future.delayed(Duration.zero, () {
              setState(() {
                // Lógica para actualizar la gráfica con los nuevos datos
              });
            });
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: const Text(
                    'Resultados',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: votosSi.toDouble(),
                            color: votosSi > 0
                                ? Colors.green.shade300
                                : Colors.grey,
                            showTitle: true,
                            title: 'Si',
                            titleStyle: const TextStyle(color: Colors.white),
                            borderSide: const BorderSide(
                              color: Color(0xFF57FF0A),
                              width: 0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          PieChartSectionData(
                            value: votosNo.toDouble(),
                            color: votosNo > 0 ? Colors.red.shade300 : Colors.grey,
                            title: 'No',
                            titleStyle: const TextStyle(color: Colors.white),
                            titlePositionPercentageOffset: 0.5,
                            badgePositionPercentageOffset: 0.9,
                            borderSide: const BorderSide(
                              color: Color(0xFFE5FF00),
                              width: 0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Text(
                    widget.pregunta,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      child: InkWell(
                        onTap: () {
                          registrarRespuesta('Si');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'Si apruebo',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 130,
                      child: InkWell(
                        onTap: () {
                          registrarRespuesta('No');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'No apruebo',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    const TableRow(
                      children: [
                        TableCell(child: Center(child: Text(' '))),
                        TableCell(child: VerticalDivider()),
                        TableCell(
                          child: Center(
                            child: Text(
                              'Coeficiente',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(child: VerticalDivider()),
                        TableCell(
                          child: Center(
                            child: Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const TableRow(
                      children: [
                        TableCell(child: Divider()),
                        TableCell(child: Divider()),
                        TableCell(child: Divider()),
                        TableCell(child: Divider()),
                        TableCell(child: Divider()),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Center(
                            child: Text(
                              'Si',
                              style: TextStyle(
                                color: Colors.green.shade300,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const TableCell(child: VerticalDivider()),
                        TableCell(
                          child: Center(
                            child: Text('${votosSi + votosNo}%'),
                          ),
                        ),
                        const TableCell(child: VerticalDivider()),
                        TableCell(
                          child: Center(
                            child: Text(
                              '${(votosSi / (votosSi + votosNo) * 100).toStringAsFixed(0)}%',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const TableRow(
                      children: [
                        TableCell(child: Divider()),
                        TableCell(child: Divider()),
                        TableCell(child: Divider()),
                        TableCell(child: Divider()),
                        TableCell(child: Divider()),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Center(
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: Colors.red.shade300,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const TableCell(child: VerticalDivider()),
                        TableCell(
                          child: Center(
                            child: Text('${votosNo + votosSi}%'),
                          ),
                        ),
                        const TableCell(child: VerticalDivider()),
                        TableCell(
                          child: Center(
                            child: Text(
                              '${(votosNo / (votosSi + votosNo) * 100).toStringAsFixed(0)}%',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                    IconButton(
            icon: Icon(Icons.group),
            onPressed: () {
              setState(() {
                showVoters = !showVoters;
              });
            },
          ),
                if (showVoters)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Usuarios que votaron:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Muestra la lista de usuarios que votaron
                        for (var document in documents)
                          Text(
                            '${document['userId']} - ${document['respuesta']}',
                            style: TextStyle(
                              color: document['respuesta'] == 'Si'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}
