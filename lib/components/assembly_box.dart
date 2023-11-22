import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final String text;
  final TextEditingController controller;
  final VoidCallback onNoPressed;
  final VoidCallback onYesPressed;
  final String noButtonText;
  final String yesButtonText;

  const CustomTextBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.text,
    required this.controller,
    required this.noButtonText, 
    required this.yesButtonText, 
    required this.onNoPressed, 
    required this.onYesPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(fontSize: 16)),
              Text(text),
              
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onNoPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text('No',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: onYesPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xE601AF6C),
                    ),
                    child: const Text('Si, continuar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      
    );
    
  }
}
