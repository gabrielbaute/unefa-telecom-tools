import 'dart:math' as math;
import '../models/complex_number.dart';

/// Servicio encargado de calcular las raíces n-ésimas de un número complejo
/// aplicando la fórmula de De Moivre.
class ComplexRootService {
  /// Calcula las n raíces complejas de un número complejo Z.
  ///
  /// Args:
  ///   [z] (ComplexNumber): El número complejo base al cual se le calculará la raíz.
  ///   [n] (int): El orden de la raíz (debe ser mayor o igual a 1).
  ///
  /// Returns:
  ///   (List&lt;ComplexNumber&gt;): Una lista con las n raíces complejas calculadas.
  ///
  /// Raises:
  ///   [ArgumentError]: Si el orden de la raíz [n] es menor a 1.
  List<ComplexNumber> calculateNthRoots(ComplexNumber z, int n) {
    if (n < 1) {
      throw ArgumentError(
        'El orden de la raíz debe ser un entero mayor o igual a 1.',
      );
    }

    final double r = z.magnitude;
    if (r == 0) {
      return List.filled(n, const ComplexNumber(real: 0, imaginary: 0));
    }

    final double theta = z.phaseRadians;
    final double nthRootMagnitude = math.pow(r, 1.0 / n).toDouble();
    List<ComplexNumber> roots = [];

    for (int k = 0; k < n; k++) {
      final double angle = (theta + (2.0 * math.pi * k)) / n;
      final double real = nthRootMagnitude * math.cos(angle);
      final double imaginary = nthRootMagnitude * math.sin(angle);
      roots.add(ComplexNumber(real: real, imaginary: imaginary));
    }

    return roots;
  }
}
