import 'package:flutter/material.dart';

/// Botón estandarizado para limpiar formularios y reiniciar estados de cálculo.
/// Diseñado para ser incrustado principalmente en las acciones del AppBar.
class ClearFormButton extends StatelessWidget {
  final VoidCallback onClear;

  const ClearFormButton({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.cleaning_services_outlined),
      tooltip: 'Limpiar Formulario',
      onPressed: onClear,
    );
  }
}
