import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/math_enums.dart';
import '../../controllers/complex_controller.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../components/custom_segmented_selector.dart';
import '../layouts/base_layout.dart';

/// Vista orquestadora para la conversión de números complejos y fasores.
class ComplexView extends StatefulWidget {
  const ComplexView({super.key});

  @override
  State<ComplexView> createState() => _ComplexViewState();
}

class _ComplexViewState extends State<ComplexView> {
  final TextEditingController _c1 = TextEditingController();
  final TextEditingController _c2 = TextEditingController();

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ComplexController>();

    // Definición de las etiquetas de los inputs según el modo activo del controlador
    final String label1 = controller.inputMode == ComplexNumMode.rectangular
        ? 'Parte Real (x)'
        : 'Magnitud (r)';

    final String label2 = controller.inputMode == ComplexNumMode.rectangular
        ? 'Parte Imaginaria (j_y)'
        : 'Ángulo (θ°)';

    return BaseLayout(
      title: 'Conversor de Fasores',
      children: <Widget>[
        // Selector de Modo de Entrada forma rectangular vs fasorial/polar
        CustomSegmentedSelector<ComplexNumMode>(
          selectedValue: controller.inputMode,
          onSelectionChanged: (newMode) {
            _c1.clear();
            _c2.clear();
            controller.setInputMode(newMode);
          },
          segments: const [
            SelectorSegmentData(
              value: ComplexNumMode.rectangular,
              label: 'Rectangular',
              icon: Icons.grid_on,
            ),
            SelectorSegmentData(
              value: ComplexNumMode.polar,
              label: 'Fasorial / Polar',
              icon: Icons.explore,
            ),
          ],
        ),

        // Fila de entradas utilizando el MathTextField refactorizado
        Row(
          children: [
            Expanded(
              child: MathTextField(
                label: label1,
                hint: '0.0',
                controller: _c1,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (_) => controller.updateValues(_c1.text, _c2.text),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MathTextField(
                label: label2,
                hint: '0.0',
                controller: _c2,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (_) => controller.updateValues(_c1.text, _c2.text),
              ),
            ),
          ],
        ),

        // Manejo de errores visuales
        if (controller.error != null)
          Text(
            controller.error!,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

        // Bloque de resultados unificado
        if (controller.result != null) ...[
          Text(
            'Formas Equivalentes:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: _formatComplexResults(controller.result!)),
        ],
      ],
    );
  }

  /// Procesa el mapa de resultados numéricos para generar los strings de ingeniería.
  Map<String, String> _formatComplexResults(Map<String, dynamic> raw) {
    double r = raw['real'] as double;
    double i = raw['imaginary'] as double;
    double mag = raw['magnitude'] as double;
    double deg = raw['phaseDegrees'] as double;
    double rad = raw['phaseRadians'] as double;

    String sign = i >= 0 ? '+' : '-';

    return {
      'Forma Rectangular:':
          '${r.toStringAsFixed(3)} $sign j${i.abs().toStringAsFixed(3)}',
      'Forma Fasorial:':
          '${mag.toStringAsFixed(3)} ∡ ${deg.toStringAsFixed(2)}°',
      'Forma Exponencial:':
          '${mag.toStringAsFixed(3)} · e^(j · ${rad.toStringAsFixed(3)} rad)',
    };
  }
}
