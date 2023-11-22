import 'package:flutter/material.dart';
import 'package:proyecto_v2/presentation/pages/files/models/archivo.dart';
import 'package:proyecto_v2/presentation/pages/files/shared/app_constants.dart';
import 'package:proyecto_v2/presentation/pages/files/shared/utils.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<Archivo> archivos = [
    Archivo(id: 1, fileName: "Horarios de atención administración", mimeType: "application/pdf", datos: AppConstants.pdfBase64),
    Archivo(id: 2, fileName: "Manual de Convivencia", mimeType: "application/pdf", datos: AppConstants2.pdfBase64),
    Archivo(id: 3, fileName: "Nota aclaratoria SSGT ARL", mimeType: "application/pdf", datos: AppConstants3.pdfBase64),
    Archivo(id: 4, fileName: "Protocolo de seguridad y salud en el trabajo", mimeType: "application/pdf", datos: AppConstants4.pdfBase64),
    Archivo(id: 5, fileName: "Opciones de pago", mimeType: "application/pdf", datos: AppConstants5.pdfBase64),
    Archivo(id: 6, fileName: "Cartilla Asamblea Torres de Timiza 2023", mimeType: "application/pdf", datos: AppConstants6.pdfBase64),
  ];

  // Define una lista de imágenes para cada elemento de la lista
  List<String> imagenes = [
    'assets/ar1.png',
    'assets/ar2.png',
    'assets/ar3.png',
    'assets/ar4.png',
    'assets/ar5.png',
    'assets/ar6.png',
  ];

   @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: const Text(""),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Documentos Públicos',
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'En este espacio encontrarás documentos públicos que podrás ver y descargar. Contiene información relevante para ti.',
            style: TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 133, 133, 133)),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: archivos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextButton(
                  onPressed: () {
                    Utils.base64ToPdf(archivos[index].datos, archivos[index].fileName, 'pdf');
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(archivos[index].fileName, style: Theme.of(context).textTheme.bodyLarge),
                    leading: Image.asset(imagenes[index], width: 100.0, height: 100.0),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
}