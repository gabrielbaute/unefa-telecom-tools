import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/math_enums.dart';
import '../../controllers/complex_calc_controller.dart';
import '../components/arithmetic_operator_selector.dart';
import '../components/clear_form_button.dart';
import '../components/custom_segmented_selector.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

class ComplexCalcView extends StatefulWidget {
  const ComplexCalcView({super.key});

  @override
  State<ComplexCalcView> createState() => _ComplexCalcViewState();
}

class _ComplexCalcViewState extends State<ComplexCalcView> {
  final TextEditingController _z1C1 = TextEditingController();
  final TextEditingController _z1C2 = TextEditingController();
  final TextEditingController _z2C1 = TextEditingController();
  final TextEditingController _z2C2 = TextEditingController();

  @override
  void dispose() {
    _z1C1.dispose();
    _z1C2.dispose();
    _z2C1.dispose();
    _z2C2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ComplexCalcController>();
    final bool isRect = controller.mode == ComplexNumMode.rectangular;

    final String label1 = isRect ? 'Real (x)' : 'Magnitud (r)';
    final String label2 = isRect ? 'Imaginario (j_y)' : 'Ángulo (θ°)';

    return BaseLayout(
      title: 'Aritmética Compleja',
      actions: [
        ClearFormButton(
          onClear: () {
            _z1C1.clear();
            _z1C2.clear();
            _z2C1.clear();
            _z2C2.clear();
            controller.clearForm();
          },
        ),
      ],
      children: <Widget>[
        // Selector de Formato de Entrada genérico
        CustomSegmentedSelector<ComplexNumMode>(
          selectedValue: controller.mode,
          onSelectionChanged: (newMode) {
            _z1C1.clear();
            _z1C2.clear();
            _z2C1.clear();
            _z2C2.clear();
            controller.setMode(newMode);
          },
          segments: const [
            SelectorSegmentData(
              value: ComplexNumMode.rectangular,
              label: 'Coordenadas Rectangulares',
              icon: Icons.grid_on,
            ),
            SelectorSegmentData(
              value: ComplexNumMode.polar,
              label: 'Forma Fasorial / Polar',
              icon: Icons.explore,
            ),
          ],
        ),

        // Inputs para el Primer Número Complejo (Z1)
        Text(
          'Número Complejo Z₁',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: MathTextField(
                label: '$label1₁',
                hint: '0.0',
                controller: _z1C1,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (_) => controller.updateZ1(_z1C1.text, _z1C2.text),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MathTextField(
                label: '$label2₁',
                hint: '0.0',
                controller: _z1C2,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (_) => controller.updateZ1(_z1C1.text, _z1C2.text),
              ),
            ),
          ],
        ),

        // Inputs para el Segundo Número Complejo (Z2)
        Text(
          'Número Complejo Z₂',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: MathTextField(
                label: '$label1₂',
                hint: '0.0',
                controller: _z2C1,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (_) => controller.updateZ2(_z2C1.text, _z2C2.text),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MathTextField(
                label: '$label2₂',
                hint: '0.0',
                controller: _z2C2,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (_) => controller.updateZ2(_z2C1.text, _z2C2.text),
              ),
            ),
          ],
        ),

        const Divider(),
        Text(
          'Operación Matemática',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),

        // Selector de operaciones
        ArithmeticOperatorSelector<ComplexOperation>(
          selectedValue: controller.operation,
          onSelectionChanged: (newOp) => controller.setOperation(newOp),
          operators: const [
            OperatorSegmentData(
              value: ComplexOperation.add,
              symbol: '+',
              tooltip: 'Suma Compleja',
            ),
            OperatorSegmentData(
              value: ComplexOperation.subtract,
              symbol: '-',
              tooltip: 'Resta Compleja',
            ),
            OperatorSegmentData(
              value: ComplexOperation.multiply,
              symbol: '×',
              tooltip: 'Multiplicación Compleja',
            ),
            OperatorSegmentData(
              value: ComplexOperation.divide,
              symbol: '÷',
              tooltip: 'División Compleja',
            ),
          ],
        ),

        if (controller.error != null)
          Text(
            controller.error!,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

        // Despliegue de Resultados
        if (controller.formattedResults.isNotEmpty &&
            controller.error == null) ...[
          Text(
            'Resultado de la Operación:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: controller.formattedResults),
        ],
      ],
    );
  }
}
