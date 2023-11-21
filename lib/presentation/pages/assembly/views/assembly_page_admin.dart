import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_v2/presentation/pages/assembly/views/question_page.dart';

class AssemblyAdminPage extends StatefulWidget {
  const AssemblyAdminPage({super.key});

  @override
  _AssemblyAdminPageState createState() => _AssemblyAdminPageState();
}

class _AssemblyAdminPageState extends State<AssemblyAdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> ordenDelEvento = [];
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Programar Asamblea'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/assembly.png',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  description = value;
                },
              ),
              const SizedBox(height: 20),
              DateTimeField(
                decoration: const InputDecoration(labelText: 'Fecha'),
                format: DateFormat('yyyy-MM-dd HH:mm'),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  }
                  return currentValue;
                },
                onChanged: (value) {
                  // Puedes guardar la fecha en una variable local si es necesario
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Orden del Día:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildOrdenDelEventoList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _mostrarDialogoAgregarElemento();
                },
                child: const Text('Agregar Elemento'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validar si todos los campos están llenos
                  if (title.isNotEmpty && description.isNotEmpty && ordenDelEvento.isNotEmpty) {
                    _programarAsamblea();
                  } else {
                    _mostrarDialogoCamposIncompletos();
                  }
                },
                child: const Text('Programar Asamblea'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrdenDelEventoList() {
    return ordenDelEvento.map((elemento) => Text(elemento)).toList();
  }

  Future<void> _mostrarDialogoAgregarElemento() async {
    String nuevoElemento = '';
    int numeroElemento = ordenDelEvento.length + 1;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Elemento'),
        content: TextFormField(
          onChanged: (value) {
            nuevoElemento = value;
          },
          decoration: const InputDecoration(
            labelText: 'Nuevo Elemento',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                ordenDelEvento.add('$numeroElemento. $nuevoElemento');
              });
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _programarAsamblea() async {
    // Obtén los valores de los campos
    String titleValue = title;
    DateTime? date = DateTime.now();
    String descriptionValue = description;

    // Crea un documento en Firebase con la información
    await _firestore.collection('asambleas').add({
      'title': titleValue,
      'date': date,
      'description': descriptionValue,
      'ordenDelEvento': ordenDelEvento,
      // Agrega más campos según sea necesario
    });

    // Muestra los detalles de la asamblea programada
    _mostrarDialogoAsambleaProgramada();
  }

  void _mostrarDialogoAsambleaProgramada() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Asamblea Programada'),
        content: const Text('La asamblea ha sido programada con éxito.'),
        actions: [
          TextButton(
            onPressed: () {
              // Cierra el cuadro de diálogo
              Navigator.pop(context);

              // Navega a la pantalla MyPieChart
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuestionsPage()),
              );
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCamposIncompletos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Campos Incompletos'),
        content: const Text('Por favor, completa todos los campos antes de programar la asamblea.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
