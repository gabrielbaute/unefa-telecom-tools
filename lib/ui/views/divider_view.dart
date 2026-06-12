import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/circuit_enums.dart';
import '../../controllers/divider_controller.dart';
import '../components/clear_form_button.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../components/custom_segmented_selector.dart';
import '../layouts/base_layout.dart';

/// Vista orquestadora para los divisores dinámicos adaptada para soportar
/// redes de resistencias en DC y redes de impedancias complejas en AC.
class DividerView extends StatefulWidget {
  const DividerView({super.key});

  @override
  State<DividerView> createState() => _DividerViewState();
}

class _ComplexInputControllers {
  final TextEditingController real;
  final TextEditingController imag;

  _ComplexInputControllers()
    : real = TextEditingController(text: "100"),
      imag = TextEditingController(text: "0");

  void dispose() {
    real.dispose();
    imag.dispose();
  }
}

class _DividerViewState extends State<DividerView> {
  // Controladores locales para la fuente de excitación
  final TextEditingController _sourceRealController = TextEditingController(
    text: "12",
  );
  final TextEditingController _sourceImagController = TextEditingController(
    text: "0",
  );

  // Lista estructurada de controladores para las N impedancias de la red
  final List<_ComplexInputControllers> _networkControllers = [];

  @override
  void dispose() {
    _sourceRealController.dispose();
    _sourceImagController.dispose();
    for (var c in _networkControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DividerController>();

    // Sincronización del ciclo de vida de los controladores de texto con el estado del Provider
    if (_networkControllers.length < controller.realValues.length) {
      while (_networkControllers.length < controller.realValues.length) {
        _networkControllers.add(_ComplexInputControllers());
      }
    } else if (_networkControllers.length > controller.realValues.length) {
      while (_networkControllers.length > controller.realValues.length) {
        _networkControllers.removeLast().dispose();
      }
    }

    final bool isAc = controller.domain == CircuitDomain.ac;

    // Configuración de textos dinámicos según el modo y tipo de circuito
    final String sourceLabelReal = controller.mode == CircuitMagnitude.voltage
        ? (isAc ? 'Voltaje Real (V_re)' : 'Voltaje de Entrada (V_in)')
        : (isAc ? 'Corriente Real (I_re)' : 'Corriente de Entrada (I_in)');

    final String sourceLabelImag = controller.mode == CircuitMagnitude.voltage
        ? 'Voltaje Imag (j_Vim)'
        : 'Corriente Imag (j_Iim)';

    return BaseLayout(
      title: 'Divisores Dinámicos',
      actions: [
        ClearFormButton(
          onClear: () {
            // 1. Restablecer controladores de la fuente de excitación
            _sourceRealController.text = "12";
            _sourceImagController.text = "0";

            // 2. Limpiar y desechar controladores dinámicos de la red
            for (var c in _networkControllers) {
              c.dispose();
            }
            _networkControllers.clear();

            // 3. Ejecutar limpieza del estado lógico
            controller.clearForm();
          },
        ),
      ],
      children: <Widget>[
        // Selector 1: Tipo de Señal (DC / AC)
        CustomSegmentedSelector<CircuitDomain>(
          selectedValue: controller.domain,
          onSelectionChanged: (newDomain) =>
              controller.setCircuitDomian(newDomain),
          segments: const [
            SelectorSegmentData(
              value: CircuitDomain.dc,
              label: 'Corriente Continua (DC)',
              icon: Icons.horizontal_rule,
            ),
            SelectorSegmentData(
              value: CircuitDomain.ac,
              label: 'Corriente Alterna (AC)',
              icon: Icons.waves,
            ),
          ],
        ),

        // Selector 2: Tipo de Divisor (Voltaje / Corriente)
        CustomSegmentedSelector<CircuitMagnitude>(
          selectedValue: controller.mode,
          onSelectionChanged: (newMode) => controller.setMode(newMode),
          segments: const [
            SelectorSegmentData(
              value: CircuitMagnitude.voltage,
              label: 'Divisor de Voltaje',
              icon: Icons.bolt,
            ),
            SelectorSegmentData(
              value: CircuitMagnitude.current,
              label: 'Divisor de Corriente',
              icon: Icons.sync_alt,
            ),
          ],
        ),

        // Bloque de Entrada de la Fuente (Excitación)
        Row(
          children: [
            Expanded(
              child: MathTextField(
                label: sourceLabelReal,
                hint: '12',
                controller: _sourceRealController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onChanged: (_) => controller.updateSource(
                  _sourceRealController.text,
                  _sourceImagController.text,
                ),
              ),
            ),
            if (isAc) ...[
              const SizedBox(width: 16),
              Expanded(
                child: MathTextField(
                  label: sourceLabelImag,
                  hint: '0',
                  controller: _sourceImagController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  onChanged: (_) => controller.updateSource(
                    _sourceRealController.text,
                    _sourceImagController.text,
                  ),
                ),
              ),
            ],
          ],
        ),

        const Divider(),

        // Cabecera de la sección de red dinámica
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Envolvemos en Expanded para que el texto largo se adapte al ancho disponible
            Expanded(
              child: Text(
                isAc
                    ? 'Impedancias de la Red (Z = R + jX)'
                    : 'Resistencias de la Red',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow
                    .ellipsis, // Si no cabe, añade "..." elegantemente al final
              ),
            ),
            const SizedBox(
              width: 8,
            ), // Un pequeño espacio de seguridad entre el texto y el botón
            TextButton.icon(
              onPressed: () => controller.addElement(),
              icon: const Icon(Icons.add),
              label: Text(isAc ? 'Añadir Z' : 'Añadir R'),
            ),
          ],
        ),

        // Renderizado Dinámico de las filas (N elementos)
        ...List.generate(controller.realValues.length, (index) {
          return Row(
            children: [
              // Entrada de la Parte Real (Resistencia pura)
              Expanded(
                child: MathTextField(
                  label: isAc
                      ? 'R_${index + 1} (Ω)'
                      : 'Resistencia R${index + 1} (Ω)',
                  hint: '100',
                  controller: _networkControllers[index].real,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => controller.updateElementValues(
                    index,
                    _networkControllers[index].real.text,
                    _networkControllers[index].imag.text,
                  ),
                ),
              ),

              // Entrada Condicional de la Parte Imaginaria (Reactancia en AC)
              if (isAc) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: MathTextField(
                    label: 'jX_${index + 1} (Ω)',
                    hint: '0',
                    controller: _networkControllers[index].imag,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    onChanged: (_) => controller.updateElementValues(
                      index,
                      _networkControllers[index].real.text,
                      _networkControllers[index].imag.text,
                    ),
                  ),
                ),
              ],

              const SizedBox(width: 4),
              // Botón para remover elemento (Deshabilitado si hay solo 2 elementos mínimo)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: controller.realValues.length > 2
                    ? () {
                        _networkControllers.removeAt(index).dispose();
                        controller.removeElement(index);
                      }
                    : null,
              ),
            ],
          );
        }),

        // Visualización de errores de parseo o indeterminaciones
        if (controller.error != null)
          Text(
            controller.error!,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

        // Despliegue de Resultados Reactivos Uniformes
        if (controller.formattedResults.isNotEmpty &&
            controller.error == null) ...[
          Text(
            isAc
                ? (controller.mode == CircuitMagnitude.voltage
                      ? 'Voltaje Complejo en cada Impedancia:'
                      : 'Corriente Compleja por cada Rama:')
                : (controller.mode == CircuitMagnitude.voltage
                      ? 'Voltaje en cada Resistencia:'
                      : 'Corriente en cada Rama:'),
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
