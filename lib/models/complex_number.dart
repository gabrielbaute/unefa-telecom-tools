import 'dart:math' as math;

/// Clase que representa un número complejo formal y encapsula
/// sus operaciones algebraicas fundamentales.
class ComplexNumber {
  final double real;
  final double imaginary;

  const ComplexNumber({required this.real, required this.imaginary});

  /// Instancia un número complejo a partir de sus coordenadas polares.
  factory ComplexNumber.fromPolar(double magnitude, double angleDegrees) {
    double angleRadians = angleDegrees * (math.pi / 180.0);
    return ComplexNumber(
      real: magnitude * math.cos(angleRadians),
      imaginary: magnitude * math.sin(angleRadians),
    );
  }

  // Getters para magnitudes de ingeniería
  double get magnitude => math.sqrt((real * real) + (imaginary * imaginary));
  double get phaseRadians => math.atan2(imaginary, real);
  double get phaseDegrees => phaseRadians * (180.0 / math.pi);

  /// Realiza la adición formal: Z1 + Z2 = (x1 + x2) + j(y1 + y2)
  ComplexNumber add(ComplexNumber other) {
    return ComplexNumber(
      real: real + other.real,
      imaginary: imaginary + other.imaginary,
    );
  }

  /// Realiza la sustracción formal: Z1 - Z2 = (x1 - x2) + j(y1 - y2)
  ComplexNumber subtract(ComplexNumber other) {
    return ComplexNumber(
      real: real - other.real,
      imaginary: imaginary - other.imaginary,
    );
  }

  /// Realiza la multiplicación: Z1 * Z2 = (x1*x2 - y1*y2) + j(x1*y2 + y1*x2)
  ComplexNumber multiply(ComplexNumber other) {
    return ComplexNumber(
      real: (real * other.real) - (imaginary * other.imaginary),
      imaginary: (real * other.imaginary) + (imaginary * other.real),
    );
  }

  /// Realiza la división aplicando el conjugado del denominador.
  ComplexNumber divide(ComplexNumber other) {
    double denominator =
        (other.real * other.real) + (other.imaginary * other.imaginary);
    if (denominator == 0) {
      throw const DivideByZeroException(
        "División por cero en el campo complejo.",
      );
    }

    double rResult =
        ((real * other.real) + (imaginary * other.imaginary)) / denominator;
    double iResult =
        ((imaginary * other.real) - (real * other.imaginary)) / denominator;

    return ComplexNumber(real: rResult, imaginary: iResult);
  }

  /// Retorna el recíproco unitario (1 / Z), vital para calcular admitancias y conductancias.
  ComplexNumber reciprocal() {
    double denominator = (real * real) + (imaginary * imaginary);
    if (denominator == 0) return const ComplexNumber(real: 0, imaginary: 0);
    return ComplexNumber(
      real: real / denominator,
      imaginary: -imaginary / denominator,
    );
  }
}

/// Excepción personalizada para el control de indeterminaciones matemáticas.
class DivideByZeroException implements Exception {
  final String message;
  const DivideByZeroException(this.message);
  @override
  String toString() => 'DivideByZeroException: $message';
}
