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
/// optimizado con escalamiento dinámico para prevenir el apiñamiento visual.
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
      // Reducimos los paddings internos por defecto del botón para ganar valiosos píxeles en los extremos
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      // Convertimos nuestra estructura limpia al formato nativo optimizado
      segments: segments.map((seg) {
        return ButtonSegment<T>(
          value: seg.value,
          // Encapsulamos el layout en un espacio vertical compacto
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  seg.icon,
                  size: 18.0,
                ), // Tamaño de ícono de ingeniería optimizado
                const SizedBox(height: 2.0),
                // FittedBox actúa como un amortiguador elástico reduciendo la fuente si el espacio colapsa
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    seg.label,
                    style: const TextStyle(
                      fontSize: 11.0, // Fuente base compacta legible
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Deshabilitamos el ícono nativo del segmento para evitar que el framework
          // intente inyectar su propio Row horizontal de manera forzada
          icon: const SizedBox.shrink(),
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
