import 'package:flutter/material.dart';

class AssemblyDetailPage extends StatelessWidget {
  final String title;
  final DateTime date;
  final List<String> ordenDelEvento;

  AssemblyDetailPage({
    required this.title,
    required this.date,
    required this.ordenDelEvento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Asamblea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Título: $title',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Fecha: ${date.toString()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Orden del Día:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildOrdenDelEventoList(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOrdenDelEventoList() {
    return ordenDelEvento.map((elemento) => Text(elemento)).toList();
  }
}
