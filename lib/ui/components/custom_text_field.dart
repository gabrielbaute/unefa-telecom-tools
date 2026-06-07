import 'package:flutter/material.dart';

/// Campo de entrada de texto genérico y estilizado bajo las pautas de Material 3.
class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final String? errorText;
  final IconData prefixIcon;
  final int maxLength;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.maxLength,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        counterText:
            '', // Mantiene el diseño limpio sin el contador por defecto
      ),
      onChanged: onChanged,
    );
  }
}
