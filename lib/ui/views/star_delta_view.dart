import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/star_delta_controller.dart';
import '../components/custom_segmented_selector.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

class StarDeltaView extends StatefulWidget {
  const StarDeltaView({super.key});

  @override
  State<StarDeltaView> createState() => _StarDeltaViewState();
}

class _StarDeltaViewState extends State<StarDeltaView> {
  final List<TextEditingController> _realControllers = List.generate(
    3,
    (_) => TextEditingController(text: "100"),
  );
  final List<TextEditingController> _imagControllers = List.generate(
    3,
    (_) => TextEditingController(text: "0"),
  );

  @override
  void dispose() {
    for (var c in _realControllers) {
      c.dispose();
    }
    for (var c in _imagControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StarDeltaController>();
    final bool isAc = controller.type == NetworkCircuitType.ac;
    final bool isDeltaToWye =
        controller.direction == ConversionDirection.deltaToWye;

    // Etiquetas fijas de los componentes dependiendo del sentido
    final List<String> inputLabels = isDeltaToWye
        ? ['Rama Z_A (Ω)', 'Rama Z_B (Ω)', 'Rama Z_C (Ω)']
        : ['Rama Z₁ (Ω)', 'Rama Z₂ (Ω)', 'Rama Z₃ (Ω)'];

    return BaseLayout(
      title: 'Conversión Estrella - Delta',
      children: <Widget>[
        // Selector 1: Dirección del Algoritmo
        CustomSegmentedSelector<ConversionDirection>(
          selectedValue: controller.direction,
          onSelectionChanged: (newDir) => controller.setDirection(newDir),
          segments: const [
            SelectorSegmentData(
              value: ConversionDirection.deltaToWye,
              label: 'Delta ➔ Estrella (Δ ➔ Upsilon)',
              icon: Icons.change_history,
            ),
            SelectorSegmentData(
              value: ConversionDirection.wyeToDelta,
              label: 'Estrella ➔ Delta (Upsilon ➔ Δ)',
              icon: Icons.device_hub,
            ),
          ],
        ),

        // Selector 2: Dominio de Frecuencia (DC / AC)
        CustomSegmentedSelector<NetworkCircuitType>(
          selectedValue: controller.type,
          onSelectionChanged: (newType) => controller.setCircuitType(newType),
          segments: const [
            SelectorSegmentData(
              value: NetworkCircuitType.dc,
              label: 'Resistencias (DC)',
              icon: Icons.horizontal_rule,
            ),
            SelectorSegmentData(
              value: NetworkCircuitType.ac,
              label: 'Impedancias (AC)',
              icon: Icons.waves,
            ),
          ],
        ),

        Text(
          'Componentes de la Red de Entrada:',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),

        // Renderizado de las 3 filas estáticas de datos
        ...List.generate(3, (index) {
          return Row(
            children: [
              Expanded(
                child: MathTextField(
                  label: isAc
                      ? '${inputLabels[index]} [Real]'
                      : inputLabels[index],
                  hint: '100',
                  controller: _realControllers[index],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => controller.updateInput(
                    index,
                    _realControllers[index].text,
                    _imagControllers[index].text,
                  ),
                ),
              ),
              if (isAc) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: MathTextField(
                    label: 'jX_${index + 1} [Imag]',
                    hint: '0',
                    controller: _imagControllers[index],
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    onChanged: (_) => controller.updateInput(
                      index,
                      _realControllers[index].text,
                      _imagControllers[index].text,
                    ),
                  ),
                ),
              ],
            ],
          );
        }),

        if (controller.error != null)
          Text(
            controller.error!,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

        // Despliegue de Resultados Equivalentes
        if (controller.formattedResults.isNotEmpty &&
            controller.error == null) ...[
          Text(
            'Red Equivalente Calculada:',
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
