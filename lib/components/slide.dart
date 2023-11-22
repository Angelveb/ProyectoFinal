import 'package:flutter/material.dart';

class Slide1 extends StatelessWidget {
  final String facturaText; // Nuevo parámetro para el texto de la factura
  const Slide1({super.key, required this.facturaText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 348,
          height: 160,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.20),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: -16,
                child: SizedBox(
                  width: 113,
                  height: 184,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 3.74,
                        top: 0,
                        child: Container(
                          width: 105.52,
                          height: 176.92,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/pay.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 131.09,
                        child: Container(
                          height: 53.25,
                          padding: const EdgeInsets.only(
                            top: 5.05,
                            left: 39.38,
                            right: 39.38,
                            bottom: 20.20,
                          ),
                          decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Archivo', // Usa el parámetro para personalizar el texto
                                    style: TextStyle(
                                      color: Color(0xFF272C2F),
                                      fontSize: 14.14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.42,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 136,
                top: 49,
                child: SizedBox(
                  width: 121,
                  height: 69,
                  child: Text(
                    facturaText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.42,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 230,
                top: 50,
                child: SizedBox(
                  width: 110,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Color del botón
                    ),
                    child: const Text(
                      'Descargar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white, // Color del texto
                        fontSize: 11,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.42,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 114,
                top: 160,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-1.57),
                  child: Container(
                    width: 160,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.50,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFF2F2F2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
