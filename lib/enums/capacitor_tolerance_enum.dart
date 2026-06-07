/// Representa las letras de tolerancia estándar para condensadores cerámicos,
/// indicando su valor porcentual o en picofaradios (pF).
enum CapacitorTolerance {
  c(letter: 'C', value: 0.25, isPercentage: false),
  d(letter: 'D', value: 0.5, isPercentage: false),
  f(letter: 'F', value: 1.0, isPercentage: true),
  g(letter: 'G', value: 2.0, isPercentage: true),
  j(letter: 'J', value: 5.0, isPercentage: true),
  k(letter: 'K', value: 10.0, isPercentage: true),
  m(letter: 'M', value: 20.0, isPercentage: true),
  z(
    letter: 'Z',
    value: 80.0,
    isPercentage: true,
  ); // Nota: Z suele ser +80% / -20%

  final String letter;
  final double value;
  final bool isPercentage;

  const CapacitorTolerance({
    required this.letter,
    required this.value,
    required this.isPercentage,
  });

  /// Retorna una descripción formateada de la tolerancia (ej: "±10%" o "±0.25 pF").
  String get displayValue => isPercentage ? '±$value%' : '±$value pF';

  /// Busca y retorna el enum correspondiente a partir de una letra.
  ///
  /// Args:
  ///   [letter] (String): La letra de tolerancia a buscar.
  ///
  /// Returns:
  ///   (CapacitorTolerance?): El enum coincidente o null si no se encuentra.
  static CapacitorTolerance? fromLetter(String letter) {
    for (var tolerance in CapacitorTolerance.values) {
      if (tolerance.letter == letter.toUpperCase()) {
        return tolerance;
      }
    }
    return null;
  }
}
