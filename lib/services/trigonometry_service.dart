import 'dart:math' as math;
import '../enums/math_enums.dart';

/// Servicio de procesamiento y cálculo para la suite de trigonometría aplicada.
///
/// Realiza las conversiones de sistemas angulares y evalúa las funciones circulares,
/// inversas e hiperbólicas controlando singularidades matemáticas.
class TrigonometryService {
  /// Convierte cualquier entrada angular al valor equivalente en Radianes nativos.
  ///
  /// Args:
  ///   value (double): Magnitud numérica del ángulo.
  ///   unit (AngleUnit): Sistema angular de origen.
  ///
  /// Returns:
  ///   double: El ángulo transformado a radianes.
  double convertToRadians(double value, AngleUnit unit) {
    switch (unit) {
      case AngleUnit.radians:
        return value;
      case AngleUnit.decimalDegrees:
        return value * (math.pi / 180.0);
      case AngleUnit.sexagesimal:
        // Nota: Los DMS se procesan de forma normalizada antes de entrar aquí.
        return value * (math.pi / 180.0);
    }
  }

  /// Convierte radianes al sistema angular de salida especificado.
  double convertFromRadians(double radians, AngleUnit unit) {
    switch (unit) {
      case AngleUnit.radians:
        return radians;
      case AngleUnit.decimalDegrees:
        return radians * (180.0 / math.pi);
      case AngleUnit.sexagesimal:
        return radians * (180.0 / math.pi);
    }
  }

  /// Evalúa las 6 funciones trigonométricas directas.
  ///
  /// Args:
  ///   rad (double): Ángulo de entrada en radianes.
  ///
  /// Returns:
  ///   Map<String, double>: Diccionario con los coeficientes calculados.
  Map<String, double> calculateDirect(double rad) {
    final double sinVal = math.sin(rad);
    final double cosVal = math.cos(rad);

    // Control riguroso de indeterminaciones por límites asintóticos
    // Tolerancia de precisión para ceros informáticos (epsilon)
    const double epsilon = 1e-15;

    final double? tanVal = cosVal.abs() < epsilon ? null : sinVal / cosVal;
    final double? secVal = cosVal.abs() < epsilon ? null : 1.0 / cosVal;
    final double? cscVal = sinVal.abs() < epsilon ? null : 1.0 / sinVal;
    final double? cotVal = sinVal.abs() < epsilon ? null : cosVal / sinVal;

    return {
      'Seno (sin)': sinVal,
      'Coseno (cos)': cosVal,
      'Tangente (tan)': tanVal ?? double.nan,
      'Secante (sec)': secVal ?? double.nan,
      'Cosecante (csc)': cscVal ?? double.nan,
      'Cotangente (cot)': cotVal ?? double.nan,
    };
  }

  /// Evalúa las funciones inversas (Arco) devolviendo el resultado en radianes.
  Map<String, double> calculateInverse(double value) {
    return {
      'Arco Seno (asin)': (value >= -1.0 && value <= 1.0)
          ? math.asin(value)
          : double.nan,
      'Arco Coseno (acos)': (value >= -1.0 && value <= 1.0)
          ? math.acos(value)
          : double.nan,
      'Arco Tangente (atan)': math.atan(value),
    };
  }

  /// Evalúa las funciones hiperbólicas directas.
  Map<String, double> calculateHyperbolic(double x) {
    // Definiciones formales: sinh(x) = (e^x - e^-x)/2 , cosh(x) = (e^x + e^-x)/2
    final double sinhVal = (math.exp(x) - math.exp(-x)) / 2.0;
    final double coshVal = (math.exp(x) + math.exp(-x)) / 2.0;
    final double tanhVal = sinhVal / coshVal;

    return {
      'Seno Hiperbólico (sinh)': sinhVal,
      'Coseno Hiperbólico (cosh)': coshVal,
      'Tangente Hiperbólico (tanh)': tanhVal,
    };
  }

  /// Convierte un valor en grados decimales a una cadena formateada en DMS (° ' ").
  ///
  /// Args:
  ///   decimalDegrees (double): Magnitud angular en formato flotante.
  ///
  /// Returns:
  ///   String: Texto estructurado con la notación formal sexagesimal.
  String formatToSexagesimal(double decimalDegrees) {
    // Manejo del signo para ángulos negativos en ingeniería
    final double absolute = decimalDegrees.abs();

    final int degrees = absolute.floor();
    final double minutesRaw = (absolute - degrees) * 60.0;
    final int minutes = minutesRaw.floor();
    final double seconds = (minutesRaw - minutes) * 60.0;

    final String sign = decimalDegrees < 0 ? '-' : '';

    // Formato estándar de alta legibilidad: D° M' S"
    return '$sign$degrees° $minutes\' ${seconds.toStringAsFixed(2)}"';
  }
}
