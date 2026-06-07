import 'package:unefa_telecom_tools/enums/resist_color_enum.dart';

/// Servicio encargado de realizar los cálculos de conversión
/// para el código de colores de las resistencias.
class ResistorCalculatorService {
  /// Calcula el valor de la resistencia y su tolerancia a partir de una lista de colores.
  ///
  /// Soporta configuraciones de 4 y 5 bandas.
  ///
  /// Args:
  ///   [bands] (List<ResistorColor>): Lista ordenada de las bandas de la resistencia.
  ///
  /// Returns:
  ///   (Map<String, dynamic>): Un mapa con el 'value' (double en Ohmios) y 'tolerance' (double).
  ///
  /// Raises:
  ///   [ArgumentError]: Si la cantidad de bandas no es 4 o 5, o si los colores no son válidos en su posición.
  Map<String, dynamic> calculateValue(List<ResistorColor> bands) {
    if (bands.length != 4 && bands.length != 5) {
      throw ArgumentError('La resistencia debe tener 4 o 5 bandas.');
    }

    int digitBandsCount = bands.length - 2;
    int baseValue = 0;

    // Calcular el valor base con los dígitos significativos
    for (int i = 0; i < digitBandsCount; i++) {
      int? bandValue = bands[i].value;
      if (bandValue == null) {
        throw ArgumentError(
          'El color ${bands[i].name} no es válido como dígito significativo.',
        );
      }
      baseValue = (baseValue * 10) + bandValue;
    }

    ResistorColor multiplierBand = bands[bands.length - 2];
    ResistorColor toleranceBand = bands.last;

    if (toleranceBand.tolerance == null) {
      throw ArgumentError(
        'El color ${toleranceBand.name} no es una banda de tolerancia válida.',
      );
    }

    double finalValue = baseValue * multiplierBand.multiplier;

    return {'value': finalValue, 'tolerance': toleranceBand.tolerance};
  }
}
