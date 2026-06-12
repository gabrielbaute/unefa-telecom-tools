import 'package:flutter/material.dart';

/// Estructura de datos que vincula un valor de operación con su representación visual.
class OperatorSegmentData<T> {
  final T value;
  final String symbol;
  final String? tooltip;

  const OperatorSegmentData({
    required this.value,
    required this.symbol,
    this.tooltip,
  });
}

/// Selector modular en hilera para operaciones aritméticas.
///
/// Utiliza genéricos <T> para adaptarse a cualquier estructura de enums de operación,
/// alternando dinámicamente entre estados activos (Filled) e inactivos (Outlined)
/// bajo los lineamientos estéticos de Material 3.
class ArithmeticOperatorSelector<T> extends StatelessWidget {
  final T selectedValue;
  final ValueChanged<T> onSelectionChanged;
  final List<OperatorSegmentData<T>> operators;

  const ArithmeticOperatorSelector({
    super.key,
    required this.selectedValue,
    required this.onSelectionChanged,
    required this.operators,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: operators.map((opData) {
        final bool isSelected = selectedValue == opData.value;
        final Widget buttonChild = Text(
          opData.symbol,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        );

        // Dimensiones estandarizadas para el área táctil (target hit) de ingeniería
        final ButtonStyle buttonStyle = ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size(64, 52)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

        Widget button = isSelected
            ? FilledButton(
                style: buttonStyle,
                onPressed: () => onSelectionChanged(opData.value),
                child: buttonChild,
              )
            : OutlinedButton(
                style: buttonStyle,
                onPressed: () => onSelectionChanged(opData.value),
                child: buttonChild,
              );

        // Si se provee tooltip institucional, envolvemos el botón para mejorar la accesibilidad
        if (opData.tooltip != null) {
          button = Tooltip(message: opData.tooltip!, child: button);
        }

        return button;
      }).toList(),
    );
  }
}
