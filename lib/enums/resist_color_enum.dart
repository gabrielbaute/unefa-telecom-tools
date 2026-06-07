/// Representa los colores del código de bandas de las resistencias
/// y sus valores numéricos asociados.
enum ResistorColor {
  black(value: 0, multiplier: 1, tolerance: null),
  brown(value: 1, multiplier: 10, tolerance: 1.0),
  red(value: 2, multiplier: 100, tolerance: 2.0),
  orange(value: 3, multiplier: 1000, tolerance: null),
  yellow(value: 4, multiplier: 10000, tolerance: null),
  green(value: 5, multiplier: 100000, tolerance: 0.5),
  blue(value: 6, multiplier: 1000000, tolerance: 0.25),
  violet(value: 7, multiplier: 10000000, tolerance: 0.1),
  grey(value: 8, multiplier: 100000000, tolerance: 0.05),
  white(value: 9, multiplier: 1000000000, tolerance: null),
  gold(value: null, multiplier: 0.1, tolerance: 5.0),
  silver(value: null, multiplier: 0.01, tolerance: 10.0);

  final int? value;
  final double multiplier;
  final double? tolerance;

  const ResistorColor({
    required this.value,
    required this.multiplier,
    required this.tolerance,
  });
}
