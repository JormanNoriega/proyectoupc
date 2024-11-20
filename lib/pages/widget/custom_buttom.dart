import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF70B71F), // Aplicar el color #3BB143
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          elevation: 5, // propiedad elevation para la sombra
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white, // Aplicar el color #1C1A00
            fontWeight: FontWeight.bold, // Aquí se aplica la negrita
          ),
        ),
      ),
    );
  }
}
