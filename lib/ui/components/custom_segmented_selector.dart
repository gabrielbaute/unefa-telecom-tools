import 'package:flutter/material.dart';

/// Clase utilitaria interna para definir las propiedades de cada segmento.
class SelectorSegmentData<T> {
  final T value;
  final String label;
  final IconData icon;

  const SelectorSegmentData({
    required this.value,
    required this.label,
    required this.icon,
  });
}

/// Un selector segmentado estandarizado y genérico para la aplicación,
/// que reduce la verbosidad de SegmentedButton de Material 3.
class CustomSegmentedSelector<T> extends StatelessWidget {
  final T selectedValue;
  final List<SelectorSegmentData<T>> segments;
  final ValueChanged<T> onSelectionChanged;

  const CustomSegmentedSelector({
    super.key,
    required this.selectedValue,
    required this.segments,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      // Convertimos nuestra estructura limpia al formato nativo exigido por Flutter
      segments: segments.map((seg) {
        return ButtonSegment<T>(
          value: seg.value,
          label: Text(seg.label),
          icon: Icon(seg.icon),
        );
      }).toList(),
      // El componente nativo exige un Set, lo extraemos del tipo simple recibido
      selected: <T>{selectedValue},
      onSelectionChanged: (Set<T> newSelection) {
        onSelectionChanged(newSelection.first);
      },
    );
  }
}
