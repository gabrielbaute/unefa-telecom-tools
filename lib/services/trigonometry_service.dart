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
  ///
  /// Args:
  ///   radians (double): Ángulo de entrada en radianes.
  ///   unit (AngleUnit): Sistema angular de destino.
  ///
  /// Returns:
  ///   double: El ángulo transformado al sistema especificado.
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
  ///   Map (String, double): Diccionario con los coeficientes calculados.
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
  ///
  /// Args:
  ///    value (double): Magnitud numérica del ángulo.
  ///
  /// Returns:
  ///    Map (string, double): Diccionario con los ángulos calculados.
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

  /// Evalúa las 6 funciones hiperbólicas directas controlando indeterminaciones.
  ///
  /// Args:
  ///   x (double): Magnitud de entrada escalar (valor real).
  ///
  /// Returns:
  ///   Map (String, double): Diccionario formal con los coeficientes calculados.
  Map<String, double> calculateHyperbolic(double x) {
    // Definiciones formales asintóticas basadas en funciones exponenciales nativas
    final double sinhVal = (math.exp(x) - math.exp(-x)) / 2.0;
    final double coshVal = (math.exp(x) + math.exp(-x)) / 2.0;

    // Control de indeterminación para puntos singulares e infinitos informáticos
    const double epsilon = 1e-15;
    final double? tanhVal = coshVal.abs() < epsilon ? null : sinhVal / coshVal;
    final double? cothVal = sinhVal.abs() < epsilon ? null : coshVal / sinhVal;
    final double? sechVal = coshVal.abs() < epsilon ? null : 1.0 / coshVal;
    final double? cschVal = sinhVal.abs() < epsilon ? null : 1.0 / sinhVal;

    return {
      'Seno Hiperbólico (sinh)': sinhVal,
      'Coseno Hiperbólico (cosh)': coshVal,
      'Tangente Hiperbólica (tanh)': tanhVal ?? double.nan,
      'Cotangente Hiperbólica (coth)': cothVal ?? double.nan,
      'Secante Hiperbólica (sech)': sechVal ?? double.nan,
      'Cosecante Hiperbólica (csch)': cschVal ?? double.nan,
    };
  }

  /// Evalúa las 6 funciones hiperbólicas inversas (Área/Arco) controlando el dominio real.
  ///
  /// Args:
  ///   x (double): Relación escalar de entrada.
  ///
  /// Returns:
  ///   Map (String, double): Diccionario formal con las magnitudes calculadas o double.nan si diverge.
  Map<String, double> calculateInverseHyperbolic(double x) {
    // 1. Argumento de Seno Hiperbólico Inverso (Admite todo el plano real R)
    final double asinhVal = math.log(x + math.sqrt(x * x + 1.0));

    // 2. Argumento de Coseno Hiperbólico Inverso (Dominio formal: x >= 1.0)
    final double acoshVal = (x >= 1.0)
        ? math.log(x + math.sqrt(x * x - 1.0))
        : double.nan;

    // 3. Argumento de Tangente Hiperbólica Inversa (Dominio formal: |x| < 1.0)
    final double atanhVal = (x.abs() < 1.0)
        ? 0.5 * math.log((1.0 + x) / (1.0 - x))
        : double.nan;

    // 4. Argumento de Cotangente Hiperbólica Inversa (Dominio formal: |x| > 1.0)
    final double acothVal = (x.abs() > 1.0)
        ? 0.5 * math.log((x + 1.0) / (x - 1.0))
        : double.nan;

    // 5. Argumento de Secante Hiperbólica Inversa (Dominio formal: 0.0 < x <= 1.0)
    // Corrección sintáctica y matemática analítica aplicada
    final double asechVal = (x > 0.0 && x <= 1.0)
        ? math.log((1.0 + math.sqrt(1.0 - x * x)) / x)
        : double.nan;

    // 6. Argumento de Cosecante Hiperbólica Inversa (Dominio formal: x != 0.0)
    final double acschVal = (x != 0.0)
        ? math.log((1.0 / x) + math.sqrt((1.0 / (x * x)) + 1.0))
        : double.nan;

    return {
      'Arco Seno Hiperbólico (asinh)': asinhVal,
      'Arco Coseno Hiperbólico (acosh)': acoshVal,
      'Arco Tangente Hiperbólica (atanh)': atanhVal,
      'Arco Cotangente Hiperbólica (acoth)': acothVal,
      'Arco Secante Hiperbólica (asech)': asechVal,
      'Arco Cosecante Hiperbólica (acsch)': acschVal,
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
