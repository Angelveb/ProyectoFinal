import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_v2/components/club_box.dart';
import 'package:proyecto_v2/presentation/pages/club/common_area_page.dart';
import 'package:proyecto_v2/presentation/pages/club/uploader_page_club.dart';
import 'package:proyecto_v2/presentation/providers/user_profile_provider.dart';

class ClubPage extends StatelessWidget {
  const ClubPage({super.key});

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          // Fondo de imagen con efecto de desenfoque
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            widthFactor: 1.0,
            heightFactor: 0.15, // Cubre el 20% superior de la pantalla
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Image.asset(
                'assets/club/vecinos.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenido sobre la imagen
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 70), // Espacio superior para el título
              Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    userProvider.torre ?? "Club House",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center, // Alinea el título al centro
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "Consulta toda la información relevante de Club House y sus zonas comunes.",
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.grey.shade800),
                  textAlign: TextAlign.center, // Alinea el texto al centro
                ),
              ),

              const SizedBox(height: 0),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomCard(
                        description: "Novedades",
                        cardColor: const Color(0xFFf4d279),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UploaderPageClub(),
                          ));
                        },
                        icon: Icons.newspaper,
                        rightIcon: Icons.newspaper,
                      ),
                  
                       /* CustomCard(
                    description: "Crear Reserva",
                    cardColor: const Color(0xFFFF8965),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ReservationPage(),
                      ));
                    },
                    icon: Icons.calendar_month,
                    rightIcon: Icons.calendar_month,
                  ), */ 
                  
                   CustomCard(
                    description: "Zonas Comunes",
                    cardColor: const Color(0xFF69F0AE),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CommonAreaPage(),
                      ));
                    },
                    icon: Icons.sports_gymnastics,
                    rightIcon: Icons.sports_gymnastics,
                  ),

                  /*CustomCard(
                    description: "Gimnasio - Piso 5",
                    cardColor: const Color(0xFFbbcd77),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ));
                    },
                    icon: Icons.sports_gymnastics,
                    rightIcon: Icons.sports_gymnastics,
                  ),

                  CustomCard(
                    description: "Salon de niños - Piso 4",
                    cardColor: const Color(0xFFbbcd77),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ));
                    },
                    icon: Icons.sports_gymnastics,
                    rightIcon: Icons.sports_gymnastics,
                  ),

                  CustomCard(
                    description: "Oxxo - Piso 1",
                    cardColor: const Color(0xFFbbcd77),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ));
                    },
                    icon: Icons.sports_gymnastics,
                    rightIcon: Icons.sports_gymnastics,
                  ),

                  CustomCard(
                    description: "Gimnasio - Piso 5",
                    cardColor: const Color(0xFFbbcd77),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ));
                    },
                    icon: Icons.sports_gymnastics,
                    rightIcon: Icons.sports_gymnastics,
                  ), */
                  
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
