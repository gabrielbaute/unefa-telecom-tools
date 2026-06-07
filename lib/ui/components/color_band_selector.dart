import 'package:flutter/material.dart';
import '../../enums/resist_color_enum.dart';

/// Componente que permite seleccionar un color específico para una banda de la resistencia.
class ColorBandSelector extends StatelessWidget {
  final String label;
  final ResistorColor selectedColor;
  final ValueChanged<ResistorColor?> onChanged;

  const ColorBandSelector({
    super.key,
    required this.label,
    required this.selectedColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            // Indicador de la banda
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // Vista previa del color físico de la banda
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _getFlutterColor(selectedColor),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
            ),
            const SizedBox(width: 16),

            // Selector Desplegable (Dropdown)
            Expanded(
              flex: 4,
              child: DropdownButton<ResistorColor>(
                value: selectedColor,
                isExpanded: true,
                underline:
                    const SizedBox(), // Elimina la línea inferior por defecto
                onChanged: onChanged,
                items: ResistorColor.values.map((ResistorColor color) {
                  return DropdownMenuItem<ResistorColor>(
                    value: color,
                    child: Text(
                      color.name.toUpperCase(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mapea el enum de nuestro dominio técnico a un objeto Color nativo de Flutter.
  Color _getFlutterColor(ResistorColor color) {
    switch (color) {
      case ResistorColor.black:
        return Colors.black;
      case ResistorColor.brown:
        return Colors.brown;
      case ResistorColor.red:
        return Colors.red;
      case ResistorColor.orange:
        return Colors.orange;
      case ResistorColor.yellow:
        return Colors.yellow;
      case ResistorColor.green:
        return Colors.green;
      case ResistorColor.blue:
        return Colors.blue;
      case ResistorColor.violet:
        return const Color(0xFFEE82EE);
      case ResistorColor.grey:
        return Colors.grey;
      case ResistorColor.white:
        return Colors.white;
      case ResistorColor.gold:
        return const Color(0xFFFFD700);
      case ResistorColor.silver:
        return const Color(0xFFC0C0C0);
    }
  }
}
