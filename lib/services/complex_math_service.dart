import '../models/complex_number.dart';

/// Servicio encargado de resolver redes eléctricas complejas (AC)
/// utilizando el modelo de datos ComplexNumber.
class ComplexMathService {
  /// Calcula la impedancia equivalente en serie: Z_eq = Z1 + Z2 + ... + Zn
  ComplexNumber calculateSeriesEquivalent(List<ComplexNumber> impedances) {
    return impedances.fold(
      const ComplexNumber(real: 0, imaginary: 0),
      (sum, z) => sum.add(z),
    );
  }

  /// Calcula la impedancia equivalente en paralelo usando admitancias: Z_eq = 1 / ( Σ (1 / Zi) )
  ComplexNumber calculateParallelEquivalent(List<ComplexNumber> impedances) {
    ComplexNumber admittanceSum = const ComplexNumber(real: 0, imaginary: 0);

    for (var z in impedances) {
      admittanceSum = admittanceSum.add(z.reciprocal());
    }

    return admittanceSum.reciprocal();
  }

  /// Resuelve un divisor de voltaje complejo para N impedancias en serie.
  /// Formula: V_zk = V_in * (Zk / Z_eq)
  List<ComplexNumber> calculateVoltageDivider(
    ComplexNumber vIn,
    List<ComplexNumber> impedances,
  ) {
    if (impedances.isEmpty) return [];

    ComplexNumber zEq = calculateSeriesEquivalent(impedances);
    if (zEq.real == 0 && zEq.imaginary == 0) {
      return List.filled(
        impedances.length,
        const ComplexNumber(real: 0, imaginary: 0),
      );
    }

    return impedances.map((zK) => vIn.multiply(zK.divide(zEq))).toList();
  }

  /// Resuelve un divisor de corriente complejo para N ramas en paralelo.
  /// Formula: I_zk = I_in * ( (1/Zk) / Y_eq )
  List<ComplexNumber> calculateCurrentDivider(
    ComplexNumber iIn,
    List<ComplexNumber> impedances,
  ) {
    if (impedances.isEmpty) return [];

    ComplexNumber yEq = const ComplexNumber(real: 0, imaginary: 0);
    for (var z in impedances) {
      yEq = yEq.add(z.reciprocal());
    }

    if (yEq.real == 0 && yEq.imaginary == 0) {
      return List.filled(
        impedances.length,
        const ComplexNumber(real: 0, imaginary: 0),
      );
    }

    return impedances.map((zK) {
      ComplexNumber yK = zK.reciprocal();
      return iIn.multiply(yK.divide(yEq));
    }).toList();
  }

  /// Transforma una red Delta (Za, Zb, Zc) a su equivalente Estrella.
  List<ComplexNumber> deltaToWye(
    ComplexNumber zA,
    ComplexNumber zB,
    ComplexNumber zC,
  ) {
    ComplexNumber sum = zA.add(zB).add(zC);
    if (sum.real == 0 && sum.imaginary == 0) {
      return List.filled(3, const ComplexNumber(real: 0, imaginary: 0));
    }

    ComplexNumber z1 = zB.multiply(zC).divide(sum);
    ComplexNumber z2 = zA.multiply(zC).divide(sum);
    ComplexNumber z3 = zA.multiply(zB).divide(sum);

    return [z1, z2, z3];
  }

  /// Transforma una red Estrella (Z1, Z2, Z3) a su equivalente Delta.
  List<ComplexNumber> wyeToDelta(
    ComplexNumber z1,
    ComplexNumber z2,
    ComplexNumber z3,
  ) {
    if (z1.real == 0 && z1.imaginary == 0 ||
        z2.real == 0 && z2.imaginary == 0 ||
        z3.real == 0 && z3.imaginary == 0) {
      throw const DivideByZeroException(
        "Indeterminación por elemento nulo en Estrella.",
      );
    }

    ComplexNumber p1 = z1.multiply(z2);
    ComplexNumber p2 = z2.multiply(z3);
    ComplexNumber p3 = z3.multiply(z1);
    ComplexNumber numeratorSum = p1.add(p2).add(p3);

    ComplexNumber zA = numeratorSum.divide(z1);
    ComplexNumber zB = numeratorSum.divide(z2);
    ComplexNumber zC = numeratorSum.divide(z3);

    return [zA, zB, zC];
  }
}
