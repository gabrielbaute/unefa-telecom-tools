import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/complex_root_controller.dart';
import '../../enums/math_enums.dart';
import '../components/clear_form_button.dart';
import '../components/custom_segmented_selector.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

/// Pantalla para el cálculo de raíces n-ésimas de un número complejo usando De Moivre.
class ComplexRootView extends StatefulWidget {
  const ComplexRootView({super.key});

  @override
  State<ComplexRootView> createState() => _ComplexRootViewState();
}

class _ComplexRootViewState extends State<ComplexRootView> {
  final TextEditingController _val1Controller = TextEditingController(
    text: '0',
  );
  final TextEditingController _val2Controller = TextEditingController(
    text: '0',
  );
  final TextEditingController _rootOrderController = TextEditingController(
    text: '2',
  );

  @override
  void dispose() {
    _val1Controller.dispose();
    _val2Controller.dispose();
    _rootOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ComplexRootController>();
    final bool isRect = controller.mode == ComplexNumMode.rectangular;

    final String label1 = isRect ? 'Parte Real (a)' : 'Magnitud (r)';
    final String label2 = isRect ? 'Parte Imaginaria (b)' : 'Ángulo (grados)';

    return BaseLayout(
      title: 'Raíces de Números Complejos',
      actions: [
        ClearFormButton(
          onClear: () {
            _val1Controller.text = '0';
            _val2Controller.text = '0';
            _rootOrderController.text = '2';
            controller.clearForm();
          },
        ),
      ],
      children: <Widget>[
        // Selector de Modo (Rectangular / Polar)
        CustomSegmentedSelector<ComplexNumMode>(
          selectedValue: controller.mode,
          onSelectionChanged: (newMode) {
            controller.setMode(newMode);
          },
          segments: const [
            SelectorSegmentData(
              value: ComplexNumMode.rectangular,
              label: 'Rectangular (a + bi)',
              icon: Icons.grid_on,
            ),
            SelectorSegmentData(
              value: ComplexNumMode.polar,
              label: 'Polar (r ∠ θ)',
              icon: Icons.compass_calibration,
            ),
          ],
        ),

        // Entradas del número complejo Z
        Row(
          children: [
            Expanded(
              child: MathTextField(
                label: label1,
                hint: '0.0',
                controller: _val1Controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (_) => controller.updateComplexValues(
                  _val1Controller.text,
                  _val2Controller.text,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MathTextField(
                label: label2,
                hint: '0.0',
                controller: _val2Controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (_) => controller.updateComplexValues(
                  _val1Controller.text,
                  _val2Controller.text,
                ),
              ),
            ),
          ],
        ),

        // Campo para el orden de la raíz (n)
        MathTextField(
          label: 'Orden de la raíz (n)',
          hint: '2',
          controller: _rootOrderController,
          keyboardType: TextInputType.number,
          onChanged: (val) => controller.updateRootOrder(val),
        ),

        // Visualización de Errores de Parseo o Formato
        if (controller.error != null)
          Text(
            controller.error!,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

        // Resultados
        if (controller.formattedResults.isNotEmpty &&
            controller.error == null) ...[
          Text(
            'Raíces Calculadas (Teorema de De Moivre):',
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
