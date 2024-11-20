import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final double? width;
  final double? height;

  const CustomDropdownButton({
    Key? key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Sombra con opacidad
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            hint,
            style: const TextStyle(
              color: Color(0xFFA7A7A7), // Color del hint
              fontSize: 16,
            ),
          ),
        ),
        isExpanded: true,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(item),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        underline: Container(), // Quitar la línea de subrayado
        style: const TextStyle(color: Colors.black), // Estilo del texto
      ),
    );
  }
}
