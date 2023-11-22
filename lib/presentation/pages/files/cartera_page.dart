import 'package:flutter/material.dart';
import 'package:proyecto_v2/components/slide.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Documentos Públicos'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                
                Image.asset('assets/votos.png'),
        
                const Slide1(facturaText: 'Horarios de atención'),
        
                const SizedBox(height: 20),
        
                const Slide1(facturaText: 'Manual de convivencia'),
        
                const SizedBox(height: 20),
        
                const Slide1(facturaText: 'Ejemplo'),
        
                const SizedBox(height: 20),
        
                const Slide1(facturaText: 'Ejemplo'), 

                
              ],
            )
            ),
        )
        );
  }
}