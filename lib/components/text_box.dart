import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  final IconData? icon;

  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // section name
              Row(
                children: [
                    Icon(
                      icon,
                      color:const Color(0xFF34A9EC)               ),
                  const SizedBox(width: 8), // Ajustar el espacio entre el icono y el texto
                  Text(
                    sectionName,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),

              // edit button
              IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.settings,
                  color: Color(0xFF34A9EC),
                ),
              ),
            ],
          ),
          // text
          Text(text),
        ],
      ),
    );
  }
}
