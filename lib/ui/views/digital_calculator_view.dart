import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/digital_enums.dart';
import '../../controllers/digital_controller.dart';
import '../components/clear_form_button.dart';
import '../components/custom_segmented_selector.dart';
import '../components/arithmetic_operator_selector.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

/// Vista para la Calculadora Aritmética Base-N del laboratorio de Digitales.
/// Permite operar dinámicamente en sistemas Binario, Octal, Decimal y Hexadecimal.
class DigitalCalculatorView extends StatefulWidget {
  const DigitalCalculatorView({super.key});

  @override
  State<DigitalCalculatorView> createState() => _DigitalCalculatorViewState();
}

class _DigitalCalculatorViewState extends State<DigitalCalculatorView> {
  final TextEditingController _op1Controller = TextEditingController(text: '0');
  final TextEditingController _op2Controller = TextEditingController(text: '0');

  @override
  void dispose() {
    _op1Controller.dispose();
    _op2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final digitalController = context.watch<DigitalController>();
    final NumeralSystem currentSystem = digitalController.calculatorSystem;

    // Ajuste dinámico del teclado según el sistema numérico seleccionado
    final TextInputType keyboardType =
        currentSystem == NumeralSystem.hexadecimal
        ? TextInputType
              .text // Permite ingresar letras A-F
        : const TextInputType.numberWithOptions(decimal: false, signed: true);

    return BaseLayout(
      title: 'Calculadora Base-N',
      actions: [
        ClearFormButton(
          onClear: () {
            // 1. Limpieza de la capa visual de presentación
            _op1Controller.text = '0';
            _op2Controller.text = '0';
            // 2. Limpieza del estado lógico en el controlador mediante el mixin
            digitalController.clearForm();
          },
        ),
      ],
      children: <Widget>[
        // Selector de Sistema de Numeración de Trabajo
        CustomSegmentedSelector<NumeralSystem>(
          selectedValue: currentSystem,
          onSelectionChanged: (newSystem) {
            _op1Controller.text = '0';
            _op2Controller.text = '0';
            digitalController.setCalculatorSystem(newSystem);
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

        // Inputs de los operandos digitales
        Text(
          'Entrada de Operandos (${currentSystem.name.toUpperCase()})',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: MathTextField(
                label: 'Operando 1',
                hint: '0',
                controller: _op1Controller,
                keyboardType: keyboardType,
                onChanged: (_) => digitalController.updateOperands(
                  _op1Controller.text,
                  _op2Controller.text,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MathTextField(
                label: 'Operando 2',
                hint: '0',
                controller: _op2Controller,
                keyboardType: keyboardType,
                onChanged: (_) => digitalController.updateOperands(
                  _op1Controller.text,
                  _op2Controller.text,
                ),
              ),
            ),
          ],
        ),

        const Divider(),
        Text(
          'Operación Aritmética Digital',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),

        // Inyección del nuevo componente genérico molecular reutilizable
        ArithmeticOperatorSelector<DigitalOperation>(
          selectedValue: digitalController.operation,
          onSelectionChanged: (newOp) => digitalController.setOperation(newOp),
          operators: const [
            OperatorSegmentData(
              value: DigitalOperation.add,
              symbol: '+',
              tooltip: 'Suma Digital',
            ),
            OperatorSegmentData(
              value: DigitalOperation.subtract,
              symbol: '-',
              tooltip: 'Resta Digital',
            ),
            OperatorSegmentData(
              value: DigitalOperation.multiply,
              symbol: '×',
              tooltip: 'Multiplicación Digital',
            ),
            OperatorSegmentData(
              value: DigitalOperation.divide,
              symbol: '÷',
              tooltip: 'División Entera (Cociente)',
            ),
          ],
        ),

        // Visualización de errores de parseo o indeterminaciones matemáticas
        if (digitalController.calculatorError != null)
          Text(
            digitalController.calculatorError!,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

        // Despliegue de Resultados Reactivos Uniformes
        if (digitalController.calculatorResults.isNotEmpty &&
            digitalController.calculatorError == null) ...[
          Text(
            'Cálculos de Ingeniería Digital:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: digitalController.calculatorResults),
        ],
      ],
    );
  }
}
