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
}
