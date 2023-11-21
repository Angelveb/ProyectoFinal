import 'package:flutter/material.dart';


class SettingsPage extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: '¿Cuál es la pregunta 1?',
      answer: 'Esta es la respuesta a la pregunta 1.',
    ),
    FAQItem(
      question: '¿Cuál es la pregunta 2?',
      answer: 'Esta es la respuesta a la pregunta 2.',
    ),
    FAQItem(
      question: '¿Cuál es la pregunta 3?',
      answer: 'Esta es la respuesta a la pregunta 3.',
    ),
    FAQItem(
      question: '¿Cuál es la pregunta 4?',
      answer: 'Esta es la respuesta a la pregunta 3.',
    ),
    FAQItem(
      question: '¿Cuál es la pregunta 5?',
      answer: 'Esta es la respuesta a la pregunta 3.',
    ),
    FAQItem(
      question: '¿Cuál es la pregunta 6?',
      answer: 'Esta es la respuesta a la pregunta 3.',
    ),
    FAQItem(
      question: '¿Cuál es la pregunta 7?',
      answer: 'Esta es la respuesta a la pregunta 3.',
    ),
    FAQItem(
      question: '¿Cuál es la pregunta 8?',
      answer: 'Esta es la respuesta a la pregunta 3.',
    ),
    FAQItem(
      question: '¿Cuál es la pregunta 9?',
      answer: 'Esta es la respuesta a la pregunta 3.',
    ),
  ];

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preguntas Frecuentes'),
      ),
      body: ListView(
        children: faqItems.map((item) {
          return FAQItemWidget(item: item);
        }).toList(),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}

class FAQItemWidget extends StatelessWidget {
  final FAQItem item;

  const FAQItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(item.question),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(item.answer),
          ),
        ],
      ),
    );
  }
}
