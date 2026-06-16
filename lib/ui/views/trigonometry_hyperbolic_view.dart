import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/math_enums.dart';
import '../../controllers/trigonometry_controller.dart';
import '../components/clear_form_button.dart';
import '../components/custom_segmented_selector.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

/// Vista de laboratorio especializada para Funciones Hiperbólicas.
/// Modula de forma adaptativa la visualización de operaciones directas o de área (inversas).
class TrigonometryHyperbolicView extends StatefulWidget {
  const TrigonometryHyperbolicView({super.key});

  @override
  State<TrigonometryHyperbolicView> createState() =>
      _TrigonometryHyperbolicViewState();
}

class _TrigonometryHyperbolicViewState
    extends State<TrigonometryHyperbolicView> {
  // Controlador de texto local para el parámetro escalar de análisis
  final TextEditingController _scalarController = TextEditingController(
    text: '0',
  );

  // Estado local para gobernar el selector de modo de la vista
  HyperbolicViewMode _currentMode = HyperbolicViewMode.direct;

  @override
  void dispose() {
    _scalarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TrigonometryController>();

    return BaseLayout(
      title: 'Funciones Hiperbólicas',
      actions: [
        ClearFormButton(
          onClear: () {
            // 1. Restablecer el campo de texto local de la interfaz
            _scalarController.text = '0';
            // 2. Limpiar el estado matemático del controlador centralizado
            controller.clearForm();
          },
        ),
      ],
      children: <Widget>[
        // --- SECCIÓN 1: Selector de Operación (Patrón Estándar de UX) ---
        Text(
          'Tipo de Operación Hiperbólica:',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        CustomSegmentedSelector<HyperbolicViewMode>(
          selectedValue: _currentMode,
          onSelectionChanged: (newMode) {
            setState(() {
              _currentMode = newMode;
            });
          },
          segments: const [
            SelectorSegmentData(
              value: HyperbolicViewMode.direct,
              label: 'Directas',
              icon: Icons.trending_up,
            ),
            SelectorSegmentData(
              value: HyperbolicViewMode.inverse,
              label: 'Inversas (Área)',
              icon: Icons.settings_backup_restore,
            ),
          ],
        ),

        // --- SECCIÓN 2: Captura de Magnitud Real (x) ---
        Text(
          'Parámetro de Entrada Escalar (x):',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        MathTextField(
          label: _currentMode == HyperbolicViewMode.direct
              ? 'Valor Real de Análisis (x)'
              : 'Relación o Argumento de Área (x)',
          hint: '0.0',
          controller: _scalarController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          onChanged: (text) => controller.updateHyperbolicInput(text),
        ),

        // --- SECCIÓN 3: Panel de Alertas por Errores de Sintaxis ---
        if (controller.hyperbolicError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            key: const ValueKey('trig_hyper_error_msg'),
            child: Text(
              controller.hyperbolicError!,
              style: const TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        // --- SECCIÓN 4: Renderizado Condicional de Resultados de Alta Precisión ---
        if (controller.hyperbolicError == null) ...[
          // Bloque Directo: Se muestra si se selecciona "direct" y hay datos procesados
          if (_currentMode == HyperbolicViewMode.direct &&
              controller.hyperbolicDirectResults.isNotEmpty) ...[
            const Divider(),
            Text(
              'Razones Hiperbólicas Directas:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            ResultDisplayCard(items: controller.hyperbolicDirectResults),
          ],

          // Bloque Inverso: Se muestra si se selecciona "inverse" y hay datos procesados
          if (_currentMode == HyperbolicViewMode.inverse &&
              controller.hyperbolicInverseResults.isNotEmpty) ...[
            const Divider(),
            Text(
              'Argumentos Hiperbólicos Inversos (Área):',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            ResultDisplayCard(items: controller.hyperbolicInverseResults),
          ],
        ],
      ],
    );
  }
}
