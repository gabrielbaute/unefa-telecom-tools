import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/capacitor_controller.dart';
import '../layouts/base_layout.dart';
import '../components/clear_form_button.dart';
import '../components/custom_text_field.dart';
import '../components/result_display_card.dart';

/// Vista orquestadora para el módulo de decodificación de condensadores.
class CapacitorView extends StatelessWidget {
  const CapacitorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CapacitorController>();

    // Centralizamos la estructura usando el nuevo BaseLayout
    return BaseLayout(
      title: 'Condensadores Cerámicos',
      actions: [
        ClearFormButton(
          onClear: () {
            controller.clearForm();
          },
        ),
      ],
      children: <Widget>[
        // Encabezado estático visual
        const _CapacitorHeaderCard(),

        // Entrada de datos desacoplada
        CustomTextField(
          label: 'Código del componente',
          hint: 'Ej: 104K, 222, 473J',
          prefixIcon: Icons.pin,
          maxLength: 4,
          errorText: controller.error,
          onChanged: (value) => controller.updateCode(value),
        ),

        // Renderizado condicional reactivo
        if (controller.result != null) ...[
          Text(
            'Resultados obtenidos:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: _formatCapacitorData(controller.result!)),
        ] else if (controller.error == null) ...[
          const Center(
            child: Text(
              'Esperando un código válido...',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ),
        ],
      ],
    );
  }

  /// Transforma los datos crudos del servicio en strings formateados para la UI.
  Map<String, String> _formatCapacitorData(Map<String, dynamic> rawData) {
    final double picofarads = rawData['picofarads'] as double;
    final double farads = rawData['farads'] as double;

    String faradsDisplay = (farads >= 1e-6)
        ? '${(farads * 1e6).toStringAsExponential(2)} µF ($farads F)'
        : (farads >= 1e-9)
        ? '${(farads * 1e9).toStringAsFixed(1)} nF'
        : '${farads.toStringAsExponential(3)} F';

    return {
      'Capacidad (pF):': '${picofarads.toStringAsFixed(0)} pF',
      'Capacidad (F):': faradsDisplay,
      'Tolerancia:': rawData['tolerance'] as String,
    };
  }
}

/// Componente local utilitario para el diseño de la cabecera
class _CapacitorHeaderCard extends StatelessWidget {
  const _CapacitorHeaderCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.developer_board, size: 64, color: Colors.amber),
            SizedBox(height: 8),
            Text(
              'Código del Condensador',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Ingrese los 3 dígitos junto con la letra de tolerancia opcional.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
