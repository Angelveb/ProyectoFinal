import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadPowerPage extends StatefulWidget {
  const DownloadPowerPage({super.key});

  @override
  _DownloadPowerPageState createState() => _DownloadPowerPageState();
}

class _DownloadPowerPageState extends State<DownloadPowerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descargar Poderes'),
      ),
      body: _buildPowerList(),
    );
  }

  Widget _buildPowerList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Poderes').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<QueryDocumentSnapshot> powers = snapshot.data!.docs;

        return ListView.builder(
          itemCount: powers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(powers[index]['Nombre'] ?? 'Sin nombre'),
              onTap: () {
                _launchURLInApp(powers[index]['ArchivoURL']);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _launchURLInApp(String? url) async {
    if (url != null && await canLaunch(url)) {
      // Abrir la URL en la aplicación, no en el navegador externo
      print('URL del archivo: $url');

      await launch(
        url,
        forceWebView: true,
        enableJavaScript: true,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      // Maneja el caso donde la URL no es válida o no se puede abrir
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No se puede abrir la URL'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }
}
