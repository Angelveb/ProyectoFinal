import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String description;
  final Color cardColor;
  final void Function()? onPressed;
  final IconData? icon;
  final IconData? rightIcon;
  const CustomCard({
    super.key,
    required this.description,
    required this.cardColor,
    this.onPressed,
    this.icon,
    this.rightIcon, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Navegación cuando se presiona la tarjeta
      child: Card(
        color: cardColor, // Color de fondo personalizado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: 300,
          height: 150,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alineación a la izquierda
                  children: [
                    const SizedBox(height: 20),
                    Icon(
                      icon,
                      color: Colors.white, // Color del ícono principal
                      size: 40.0, // Tamaño del ícono principal
                    ),
                    const SizedBox(height: 20),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                right: 30, // Posición del segundo ícono (puedes ajustar esto)
                child: Icon(
                  rightIcon,
                  color: Colors.white.withOpacity(
                      0.4), // Color del ícono derecho con transparencia
                  size: 60, // Tamaño del ícono derecho
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
