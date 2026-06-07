import 'package:unefa_telecom_tools/enums/capacitor_tolerance_enum.dart';

/// Servicio encargado de decodificar el marcado de los
/// condensadores cerámicos y convertirlo a Faradios.
class CeramicCapacitorService {
  /// Decodifica el código de un condensador cerámico (ej. "104K") a su valor en Faradios.
  ///
  /// Args:
  ///   [code] (String): El código alfanumérico del condensador.
  ///
  /// Returns:
  ///   (Map<String, dynamic>): Un mapa con el 'farads' (double), 'picofarads' (double) y 'tolerance' (String).
  ///
  /// Raises:
  ///   [FormatException]: Si el formato del código no cumple con la nomenclatura estándar.
  Map<String, dynamic> decodeCode(String code) {
    String cleanCode = code.trim().toUpperCase();

    if (cleanCode.length < 3) {
      throw FormatException(
        'El código del condensador debe tener al menos 3 caracteres.',
      );
    }

    final RegExp regex = RegExp(r'^(\d{3})([A-Z])?$');
    final RegExpMatch? match = regex.firstMatch(cleanCode);

    if (match == null) {
      throw FormatException(
        'Formato de código inválido. Ejemplos válidos: 103, 224K, 471J',
      );
    }

    String digitsPart = match.group(1)!;
    String? toleranceLetter = match.group(2);

    int digit1 = int.parse(digitsPart[0]);
    int digit2 = int.parse(digitsPart[1]);
    int multiplier = int.parse(digitsPart[2]);

    // Calcular valor en picofaradios (pF): AB * 10^C
    double picofarads =
        ((digit1 * 10) + digit2) * _dynamicPowerOfTen(multiplier);
    double farads = picofarads * 1e-12;

    // Obtener la tolerancia utilizando el nuevo Enum
    String toleranceDisplay = 'No especificada';
    if (toleranceLetter != null) {
      CapacitorTolerance? tolerance = CapacitorTolerance.fromLetter(
        toleranceLetter,
      );
      if (tolerance != null) {
        toleranceDisplay = tolerance.displayValue;
      }
    }

    return {
      'farads': farads,
      'picofarads': picofarads,
      'tolerance': toleranceDisplay,
    };
  }

  /// Auxiliar para calcular potencias de 10 de forma segura.
  double _dynamicPowerOfTen(int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }
}
