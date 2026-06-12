import '../enums/digital_enums.dart';

/// Modelo inmutable que representa un número en el dominio de la electrónica digital.
/// Encapsula las conversiones formales entre diferentes sistemas de numeración.
class DigitalNumber {
  final int value;

  const DigitalNumber(this.value);

  /// Construye un DigitalNumber a partir de una cadena y su sistema de numeración.
  ///
  /// Args:
  ///   text (String): La representación en texto del número.
  ///   system (NumeralSystem): El sistema de origen (binario, octal, etc.).
  ///
  /// Returns:
  ///   DigitalNumber: El objeto instanciado con el valor entero interno.
  ///
  /// Raises:
  ///   FormatException: Si la cadena no corresponde al formato del sistema indicado.
  factory DigitalNumber.fromString(String text, NumeralSystem system) {
    final String cleanText = text.trim().replaceAll(' ', '');
    if (cleanText.isEmpty) return const DigitalNumber(0);

    int rad;
    switch (system) {
      case NumeralSystem.binario:
        rad = 2;
        break;
      case NumeralSystem.octal:
        rad = 8;
        break;
      case NumeralSystem.decimal:
        rad = 10;
        break;
      case NumeralSystem.hexadecimal:
        rad = 16;
        break;
    }

    final int? parsed = int.tryParse(cleanText, radix: rad);
    if (parsed == null) {
      throw FormatException('Formato no válido para el sistema ${system.name}');
    }

    return DigitalNumber(parsed);
  }

  /// Devuelve la representación en cadena del número según el sistema solicitado.
  ///
  /// Args:
  ///   system (NumeralSystem): El sistema de numeración deseado.
  ///
  /// Returns:
  ///   String: El número formateado en el sistema destino.
  String toSystemString(NumeralSystem system) {
    switch (system) {
      case NumeralSystem.binario:
        return value.toRadixString(2).toUpperCase();
      case NumeralSystem.octal:
        return value.toRadixString(8).toUpperCase();
      case NumeralSystem.decimal:
        return value.toRadixString(10);
      case NumeralSystem.hexadecimal:
        return value.toRadixString(16).toUpperCase();
    }
  }

  // --- Operaciones Aritméticas Encapsuladas ---

  DigitalNumber add(DigitalNumber other) => DigitalNumber(value + other.value);

  DigitalNumber subtract(DigitalNumber other) =>
      DigitalNumber(value - other.value);

  DigitalNumber multiply(DigitalNumber other) =>
      DigitalNumber(value * other.value);

  DigitalNumber divide(DigitalNumber other) {
    if (other.value == 0)
      throw UnsupportedError('División por cero en aritmética digital.');
    return DigitalNumber(
      value ~/ other.value,
    ); // División entera (Bits de magnitud)
  }
}
