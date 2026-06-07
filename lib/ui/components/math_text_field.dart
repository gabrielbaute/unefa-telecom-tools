import 'package:flutter/material.dart';

/// Campo de entrada de texto genérico, adaptado para soportar configuraciones
/// numéricas de ingeniería y controladores dinámicos.
class MathTextField extends StatelessWidget {
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final TextInputType keyboardType; // Permite cambiar a teclado numérico

  const MathTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.controller,
    this.keyboardType = TextInputType.text, // Por defecto es texto común
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
