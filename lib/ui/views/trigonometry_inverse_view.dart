import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/math_enums.dart';
import '../../controllers/trigonometry_controller.dart';
import '../components/clear_form_button.dart';
import '../components/custom_segmented_selector.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

/// Vista para el cálculo exclusivo de Funciones Inversas (Arco).
/// Procesa una relación escalar y la transforma en magnitudes angulares.
class TrigonometryInverseView extends StatefulWidget {
  const TrigonometryInverseView({super.key});

  @override
  State<TrigonometryInverseView> createState() =>
      _TrigonometryInverseViewState();
}

class _TrigonometryInverseViewState extends State<TrigonometryInverseView> {
  final TextEditingController _scalarController = TextEditingController(
    text: '0',
  );

  @override
  void dispose() {
    _scalarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TrigonometryController>();

    return BaseLayout(
      title: 'Funciones Arco',
      actions: [
        ClearFormButton(
          onClear: () {
            _scalarController.text = '0';
            controller.clearForm();
          },
        ),
      ],
      children: <Widget>[
        // Entrada escalar pura de la relación geométrica
        Text(
          'Relación de Magnitud Escalar:',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        MathTextField(
          label: 'Valor de entrada (Dominio [-1, 1] para asin/acos)',
          hint: '0.5',
          controller: _scalarController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          onChanged: (text) => controller.updateInverseInput(text),
        ),

        const Divider(),

        // Selector de Unidad de Salida (Etiquetas cortas anti-apiñamiento)
        Text(
          'Formato del Ángulo de Salida:',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        CustomSegmentedSelector<AngleUnit>(
          selectedValue: controller.inverseOutputUnit,
          onSelectionChanged: (newUnit) =>
              controller.setInverseOutputUnit(newUnit),
          segments: const [
            SelectorSegmentData(
              value: AngleUnit.decimalDegrees,
              label: 'Grados',
              icon: Icons.architecture,
            ),
            SelectorSegmentData(
              value: AngleUnit.sexagesimal,
              label: 'DMS',
              icon: Icons.av_timer,
            ),
            SelectorSegmentData(
              value: AngleUnit.radians,
              label: 'Radianes',
              icon: Icons.pie_chart_outline,
            ),
          ],
        ),

        if (controller.inverseError != null)
          Text(
            controller.inverseError!,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

        // Despliegue Limpio de Resultados Ángulares
        if (controller.inverseResults.isNotEmpty &&
            controller.inverseError == null) ...[
          const Divider(),
          Text(
            'Resultados de Arcos Trigonométricos:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: controller.inverseResults),
        ],
      ],
    );
  }
}
