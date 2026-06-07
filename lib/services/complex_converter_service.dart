import 'dart:math' as math;

/// Servicio encargado de realizar las conversiones matemáticas entre las formas
/// rectangular, fasorial y exponencial de números complejos.
class ComplexConverterService {
  /// Convierte una representación rectangular (x + jy) a todas las formas.
  ///
  /// Args:
  ///   [real] (double): Parte real del número complejo.
  ///   [imaginary] (double): Parte imaginaria del número complejo.
  ///
  /// Returns:
  ///   (Map<String, double>): Mapa con 'magnitude', 'phaseDegrees' y 'phaseRadians'.
  Map<String, double> fromRectangular(double real, double imaginary) {
    double magnitude = math.sqrt((real * real) + (imaginary * imaginary));
    double phaseRadians = math.atan2(imaginary, real);
    double phaseDegrees = phaseRadians * (180.0 / math.pi);

    return {
      'magnitude': magnitude,
      'phaseDegrees': phaseDegrees,
      'phaseRadians': phaseRadians,
    };
  }

  /// Convierte una representación fasorial/polar (r y theta) a todas las formas.
  ///
  /// Args:
  ///   [magnitude] (double): Magnitud o módulo del vector.
  ///   [phaseDegrees] (double): Ángulo o fase expresado en grados sexagesimales.
  ///
  /// Returns:
  ///   (Map<String, double>): Mapa con 'real' y 'imaginary'.
  Map<String, double> fromFasorial(double magnitude, double phaseDegrees) {
    double phaseRadians = phaseDegrees * (math.pi / 180.0);
    double real = magnitude * math.cos(phaseRadians);
    double imaginary = magnitude * math.sin(phaseRadians);

    return {'real': real, 'imaginary': imaginary};
  }
}
