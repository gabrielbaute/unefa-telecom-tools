import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/math_enums.dart';
import '../../controllers/trigonometry_controller.dart';
import '../components/clear_form_button.dart';
import '../components/custom_segmented_selector.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

/// Vista para el laboratorio de Funciones Trigonométricas Directas e Hiperbólicas.
/// Modula de forma adaptativa entradas angulares en formatos Decimal, DMS o Radianes.
class TrigonometryDirectView extends StatefulWidget {
  const TrigonometryDirectView({super.key});

  @override
  State<TrigonometryDirectView> createState() => _TrigonometryDirectViewState();
}

class _TrigonometryDirectViewState extends State<TrigonometryDirectView> {
  // Controladores locales para la entrada escalar estándar
  final TextEditingController _mainInputController = TextEditingController(
    text: '0',
  );

  // Controladores locales específicos para el formato Sexagesimal (DMS)
  final TextEditingController _degreesController = TextEditingController(
    text: '0',
  );
  final TextEditingController _minutesController = TextEditingController(
    text: '0',
  );
  final TextEditingController _secondsController = TextEditingController(
    text: '0',
  );

  @override
  void dispose() {
    _mainInputController.dispose();
    _degreesController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TrigonometryController>();

    // Vinculación estricta al pipeline de variables directas del controlador refactorizado
    final AngleUnit currentUnit = controller.directUnit;
    final bool isSexagesimal = currentUnit == AngleUnit.sexagesimal;

    return BaseLayout(
      title: 'Funciones Directas',
      actions: [
        ClearFormButton(
          onClear: () {
            // 1. Limpieza de los campos de texto locales de la UI
            _mainInputController.text = '0';
            _degreesController.text = '0';
            _minutesController.text = '0';
            _secondsController.text = '0';
            // 2. Limpieza del estado matemático en el controlador (mixin)
            controller.clearForm();
          },
        ),
      ],
      children: <Widget>[
        // --- SECCIÓN 1: Selector del Sistema Angular (Optimizado contra apiñamiento) ---
        Text(
          'Sistema de Entrada Angular:',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        CustomSegmentedSelector<AngleUnit>(
          selectedValue: currentUnit,
          onSelectionChanged: (newUnit) {
            // Al conmutar el sistema angular, restablecemos los campos locales para evitar conflictos de formato
            _mainInputController.text = '0';
            _degreesController.text = '0';
            _minutesController.text = '0';
            _secondsController.text = '0';
            controller.setDirectUnit(newUnit);
          },
          segments: const [
            SelectorSegmentData(
              value: AngleUnit.decimalDegrees,
              label: 'Grados', // Etiqueta corta anti-colisión
              icon: Icons.architecture,
            ),
            SelectorSegmentData(
              value: AngleUnit.sexagesimal,
              label: 'DMS', // Etiqueta corta anti-colisión
              icon: Icons.av_timer,
            ),
            SelectorSegmentData(
              value: AngleUnit.radians,
              label: 'Radianes', // Etiqueta corta anti-colisión
              icon: Icons.pie_chart_outline,
            ),
          ],
        ),

        // --- SECCIÓN 2: Formulario Adaptativo de Entrada ---
        Text(
          isSexagesimal
              ? 'Magnitud Angular Sexagesimal:'
              : 'Magnitud Angular Escalar:',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),

        // Bifurcación visual declarativa basada en el estado de la unidad
        if (!isSexagesimal)
          MathTextField(
            label: currentUnit == AngleUnit.radians
                ? 'Ángulo en Radianes (rad)'
                : 'Ángulo en Grados (°)',
            hint: '0.0',
            controller: _mainInputController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            onChanged: (text) => controller.updateDirectInput(text),
          )
        else
          Row(
            children: [
              Expanded(
                child: MathTextField(
                  label: 'Grados (°)',
                  hint: '45',
                  controller: _degreesController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: true,
                  ),
                  onChanged: (_) => _dispatchDmsUpdate(controller),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MathTextField(
                  label: 'Minutos (\')',
                  hint: '30',
                  controller: _minutesController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  onChanged: (_) => _dispatchDmsUpdate(controller),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MathTextField(
                  label: 'Segundos (")',
                  hint: '0',
                  controller: _secondsController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  onChanged: (_) => _dispatchDmsUpdate(controller),
                ),
              ),
            ],
          ),

        // --- SECCIÓN 3: Alertas y Errores Analíticos de la Vía Directa ---
        if (controller.directError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            key: const ValueKey('trig_direct_error_msg'),
            child: Text(
              controller.directError!,
              style: const TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        // --- SECCIÓN 4: Hoja Segmentada de Resultados Trigonométricos ---
        if (controller.directResults.isNotEmpty &&
            controller.directError == null) ...[
          const Divider(),
          Text(
            'Coeficientes de Relación Directa e Hiperbólica:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: controller.directResults),
        ],
      ],
    );
  }

  /// Método helper privado para empaquetar y despachar los cambios del formulario DMS.
  void _dispatchDmsUpdate(TrigonometryController controller) {
    controller.updateDmsInput(
      _degreesController.text,
      _minutesController.text,
      _secondsController.text,
    );
  }
}
