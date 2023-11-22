import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final Function(String)? validationFunction;
  final bool showVisibilityIcon;
  final int fieldIndex;
  final Icon? prefixIcon;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.validationFunction,
    this.showVisibilityIcon = true,
    this.prefixIcon,
    required this.fieldIndex,
    this.controller,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.fieldIndex == 1 || widget.fieldIndex == 2;
    return TextField(
      controller: widget.controller,
      onChanged: widget.validationFunction,
      obscureText: isPassword && !_isVisible,
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        prefixIcon: widget.prefixIcon !=
                null // Verifica si se proporcionó un ícono
            ? Icon(
                widget.prefixIcon!.icon,
                color: Colors.grey.shade400, // Establece el color del ícono a blanco
              )
            : null,
        suffixIcon: widget.showVisibilityIcon
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isVisible = !_isVisible;
                  });
                },
                icon: _isVisible
                    ? Icon(
                        Icons.visibility,
                        color: Colors.grey.shade400,
                      )
                    : Icon(
                        Icons.visibility_off,
                        color: Colors.grey.shade400,
                      ),
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0XFFBA704F),
            width: 2,
          ),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
      ),
    );
  }
}
