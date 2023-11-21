import 'package:flutter/material.dart';

class DetallesAsambleaInfoPage extends StatelessWidget {
  final String titulo; // Puedes agregar más campos según sea necesario
  final String descripcion;
  final List<String> ordenDelEvento;

  DetallesAsambleaInfoPage({
    required this.titulo,
    required this.descripcion,
    required this.ordenDelEvento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Asamblea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: $titulo'),
            SizedBox(height: 10),
            Text('Descripción: $descripcion'),
            SizedBox(height: 10),
            Text(
              'Orden del Día:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ordenDelEvento.map((elemento) => Text(elemento)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
