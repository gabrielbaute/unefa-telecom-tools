import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/resistor_controller.dart';
import '../../enums/resist_color_enum.dart';
import '../components/color_band_selector.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

/// Vista orquestadora para el cálculo de resistencias por código de colores.
class ResistorView extends StatelessWidget {
  const ResistorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ResistorController>();

    // Disparamos el cálculo inicial si el resultado aún no se ha computado
    if (controller.result == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.calculate();
      });
    }

    return BaseLayout(
      title: 'Código de Resistencias',
      children: <Widget>[
        // Gráfico o cabecera explicativa
        const _ResistorHeaderCard(),

        // Generación dinámica de los selectores de bandas basados en el estado del controlador
        ...List.generate(controller.selectedBands.length, (index) {
          String label = _getBandLabel(index, controller.selectedBands.length);
          return ColorBandSelector(
            label: label,
            selectedColor: controller.selectedBands[index],
            onChanged: (ResistorColor? newColor) {
              if (newColor != null) {
                controller.updateBand(index, newColor);
              }
            },
          );
        }),

        // Bloque reactivo de resultados
        if (controller.result != null) ...[
          Text(
            'Valor Calculado:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: _formatResistorData(controller.result!)),
        ],
      ],
    );
  }

  /// Retorna el nombre técnico de la banda según su posición física y el total de bandas.
  String _getBandLabel(int index, int totalBands) {
    if (index == totalBands - 2) return 'Multiplicador';
    if (index == totalBands - 1) return 'Tolerancia';
    return 'Banda ${index + 1}';
  }

  /// Formatea los Ohmios crudos en kiloohmios (kΩ) o megaohmios (MΩ) para lenguaje de ingeniería.
  Map<String, String> _formatResistorData(Map<String, dynamic> rawData) {
    final double ohms = rawData['value'] as double;
    final double tolerance = rawData['tolerance'] as double;

    String ohmsDisplay;
    if (ohms >= 1e6) {
      ohmsDisplay = '${(ohms / 1e6).toStringAsFixed(2)} MΩ';
    } else if (ohms >= 1e3) {
      ohmsDisplay = '${(ohms / 1e3).toStringAsFixed(2)} kΩ';
    } else {
      ohmsDisplay = '${ohms.toStringAsFixed(0)} Ω';
    }

    return {'Resistencia Nominal:': ohmsDisplay, 'Tolerancia:': '±$tolerance%'};
  }
}

/// Componente local utilitario para el diseño de la cabecera
class _ResistorHeaderCard extends StatelessWidget {
  const _ResistorHeaderCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.tune, size: 64, color: Colors.teal),
            SizedBox(height: 8),
            Text(
              'Cálculo de Bandas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Seleccione los colores de izquierda a derecha. El sistema procesará el valor nominal y su tolerancia.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
