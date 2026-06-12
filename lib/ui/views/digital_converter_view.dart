import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/digital_enums.dart';
import '../../controllers/digital_controller.dart';
import '../components/clear_form_button.dart';
import '../components/custom_segmented_selector.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

/// Vista para el Conversor Universal de Bases del laboratorio de Digitales.
/// Realiza conversiones en tiempo real entre sistemas numéricos síncronamente.
class DigitalConverterView extends StatefulWidget {
  const DigitalConverterView({super.key});

  @override
  State<DigitalConverterView> createState() => _DigitalConverterViewState();
}

class _DigitalConverterViewState extends State<DigitalConverterView> {
  final TextEditingController _inputController = TextEditingController(
    text: '0',
  );

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final digitalController = context.watch<DigitalController>();
    final NumeralSystem currentSystem = digitalController.converterSystem;

    // Configuración dinámica del teclado según el sistema de origen actual
    final TextInputType keyboardType =
        currentSystem == NumeralSystem.hexadecimal
        ? TextInputType
              .text // Alfanumérico para soportar caracteres A-F
        : const TextInputType.numberWithOptions(decimal: false, signed: false);

    return BaseLayout(
      title: 'Conversor de Bases',
      // Inyección consistente de nuestro botón de limpieza atómico
      actions: [
        ClearFormButton(
          onClear: () {
            // 1. Limpieza de la caja de texto en la capa visual
            _inputController.text = '0';
            // 2. Limpieza del estado matemático en el controlador mediante el mixin
            digitalController.clearForm();
          },
        ),
      ],
      children: <Widget>[
        // Selector del Sistema Numérico de Origen
        Text(
          'Seleccione el Sistema de Entrada:',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        CustomSegmentedSelector<NumeralSystem>(
          selectedValue: currentSystem,
          onSelectionChanged: (newSystem) {
            // Al cambiar la base de origen, reseteamos para mitigar errores de formato previos
            _inputController.text = '0';
            digitalController.updateConverterInput('0', newSystem);
          },
          segments: const [
            SelectorSegmentData(
              value: NumeralSystem.binario,
              label: 'BIN',
              icon: Icons.pin,
            ),
            SelectorSegmentData(
              value: NumeralSystem.octal,
              label: 'OCT',
              icon: Icons.tag,
            ),
            SelectorSegmentData(
              value: NumeralSystem.decimal,
              label: 'DEC',
              icon: Icons.onetwothree,
            ),
            SelectorSegmentData(
              value: NumeralSystem.hexadecimal,
              label: 'HEX',
              icon: Icons.abc,
            ),
          ],
        ),

        // Campo de entrada unificado para la base seleccionada
        Text(
          'Magnitud de Entrada (${currentSystem.name.toUpperCase()})',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        MathTextField(
          label: 'Valor a convertir',
          hint: 'Ej. ${_getHintForSystem(currentSystem)}',
          controller: _inputController,
          keyboardType: keyboardType,
          onChanged: (text) =>
              digitalController.updateConverterInput(text, currentSystem),
        ),

        // Captura y despliegue estético de excepciones de parseo (caracteres fuera de base)
        if (digitalController.converterError != null)
          Text(
            digitalController.converterError!,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

        // Panel de Resultados Cruzados Simultáneos (Matriz Base-N)
        if (digitalController.convertedResults.isNotEmpty &&
            digitalController.converterError == null) ...[
          const Divider(),
          Text(
            'Equivalencias de Sistemas:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: digitalController.convertedResults),
        ],
      ],
    );
  }

  /// Helper privado para guiar al usuario con el formato del placeholder (hint).
  String _getHintForSystem(NumeralSystem system) {
    switch (system) {
      case NumeralSystem.binario:
        return '10110';
      case NumeralSystem.octal:
        return '755';
      case NumeralSystem.decimal:
        return '255';
      case NumeralSystem.hexadecimal:
        return 'FF3A';
    }
  }
}
