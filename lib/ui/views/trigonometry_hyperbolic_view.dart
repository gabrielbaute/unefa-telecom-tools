import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/trigonometry_controller.dart';
import '../components/clear_form_button.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

/// Vista de laboratorio especializada para Funciones Hiperbólicas Directas e Inversas.
/// Evalúa magnitudes escalares en el plano real controlando asíntotas logarítmicas.
class TrigonometryHyperbolicView extends StatefulWidget {
  const TrigonometryHyperbolicView({super.key});

  @override
  State<TrigonometryHyperbolicView> createState() =>
      _TrigonometryHyperbolicViewState();
}

class _TrigonometryHyperbolicViewState
    extends State<TrigonometryHyperbolicView> {
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
      title: 'Funciones Hiperbólicas',
      actions: [
        ClearFormButton(
          onClear: () {
            _scalarController.text = '0';
            controller.clearForm();
          },
        ),
      ],
      children: <Widget>[
        // --- SECCIÓN 1: Captura de Magnitud Real ---
        Text(
          'Parámetro de Entrada Escalar (x):',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        MathTextField(
          label: 'Valor Real de Análisis',
          hint: '0.0',
          controller: _scalarController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          onChanged: (text) => controller.updateHyperbolicInput(text),
        ),

        // --- SECCIÓN 2: Panel de Alertas por Indeterminaciones ---
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

        // --- SECCIÓN 3: Resultados de Proyección Directa ---
        if (controller.hyperbolicDirectResults.isNotEmpty &&
            controller.hyperbolicError == null) ...[
          const Divider(),
          Text(
            'Razones Hiperbólicas Directas:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: controller.hyperbolicDirectResults),
        ],

        // --- SECCIÓN 4: Resultados de Operadores Inversos (Área) ---
        if (controller.hyperbolicInverseResults.isNotEmpty &&
            controller.hyperbolicError == null) ...[
          const SizedBox(height: 16),
          Text(
            'Argumentos Hiperbólicos Inversos (Área):',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: controller.hyperbolicInverseResults),
        ],
      ],
    );
  }
}
