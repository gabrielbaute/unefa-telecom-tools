/// Servicio encargado de realizar los cálculos matemáticos para divisores
/// de voltaje y corriente con N cantidad de resistencias.
class DividerCalculatorService {
  /// Calcula las caídas de voltaje para una lista dinámica de resistencias en serie.
  ///
  /// Args:
  ///   [vIn] (double): Voltaje de entrada de la fuente.
  ///   [resistances] (List<double>): Lista con los valores en Ohmios de cada resistencia.
  ///
  /// Returns:
  ///   (List<double>): Lista con las caídas de voltaje correspondientes a cada resistencia.
  List<double> calculateVoltageDivider(double vIn, List<double> resistances) {
    if (resistances.isEmpty) return [];

    // Sumatoria de R para la resistencia equivalente
    double rEq = resistances.fold(0.0, (sum, r) => sum + r);
    if (rEq == 0) return List.filled(resistances.length, 0.0);

    // Aplicar la ecuación formal a cada elemento
    return resistances.map((r) => vIn * (r / rEq)).toList();
  }

  /// Calcula la distribución de corriente para una lista dinámica de resistencias en paralelo.
  ///
  /// Args:
  ///   [iIn] (double): Corriente total de entrada al nodo.
  ///   [resistances] (List<double>): Lista con los valores en Ohmios de cada rama.
  ///
  /// Returns:
  ///   (List<double>): Lista con la corriente que circula por cada resistencia.
  List<double> calculateCurrentDivider(double iIn, List<double> resistances) {
    if (resistances.isEmpty) return [];

    // Calcular la conductancia equivalente (Sumatoria de 1/R)
    double gEq = 0.0;
    for (double r in resistances) {
      if (r > 0) {
        gEq += (1.0 / r);
      }
    }

    if (gEq == 0) return List.filled(resistances.length, 0.0);

    // Calcular la corriente de cada rama basada en su conductancia
    return resistances.map((r) {
      if (r <= 0) return 0.0;
      double gK = 1.0 / r;
      return iIn * (gK / gEq);
    }).toList();
  }
}
