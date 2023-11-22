import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AssemblyDetailPage extends StatelessWidget {
  const AssemblyDetailPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Asamblea'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("asambleas")
            .doc('c7YZHItZb5seMnZVxUAr')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final assemblyData = snapshot.data?.data() as Map<String, dynamic>;

            // Formatea la fecha utilizando DateFormat
            DateTime date = assemblyData['date'].toDate(); // Convierte el Timestamp a DateTime
            String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);

            // Obtén la lista de ordenDelEvento
            List<dynamic> ordenDelEvento = assemblyData['ordenDelEvento'] ?? [];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha: $formattedDate',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Título: ${assemblyData['title']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Descripción: ${assemblyData['description']}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Orden del evento:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Usa un ListView.builder para mostrar la lista
                  Expanded(
                    child: Card(
                      elevation: 5,
                      child: ListView.builder(
                        itemCount: ordenDelEvento.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              '  ${ordenDelEvento[index]}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los datos: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
