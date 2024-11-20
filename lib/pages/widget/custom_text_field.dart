import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final Widget? suffixIcon; // Para íconos opcionales
  final Function(String)? onChanged; // Para manejar cambios en el texto
  final FocusNode? focusNode; // Para gestionar el foco del campo
  final int? minLines; // Para texto de varias líneas
  final int? maxLines; // Para permitir múltiples líneas
  final TextInputType? keyboardType; // Tipo de teclado

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.suffixIcon,
    this.onChanged,
    this.focusNode,
    this.minLines = 1, // Predeterminado: 1 línea
    this.maxLines = 1, // Predeterminado: 1 línea
    this.keyboardType, // Tipo de teclado personalizado
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Sombra con opacidad
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        onChanged: onChanged,
        focusNode: focusNode,
        minLines: minLines, // Mínimo de líneas
        maxLines: maxLines, // Máximo de líneas
        keyboardType: keyboardType ?? TextInputType.text, // Tipo de teclado
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: const TextStyle(
            color: Color(0xFFA7A7A7), // Color del hint
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
