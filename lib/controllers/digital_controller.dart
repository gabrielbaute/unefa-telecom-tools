import 'package:flutter/material.dart';
import '../enums/digital_enums.dart';
import '../models/digital_number.dart';
import '../mixins/cleanable_form.dart';

/// Controlador centralizado para la gestión de estados lógicos y aritméticos
/// del laboratorio de Electrónica Digital.
class DigitalController extends ChangeNotifier with CleanableForm {
  // --- Estado del Conversor Universal ---
  String _converterInput = "0";
  NumeralSystem _converterSystem = NumeralSystem.decimal;
  Map<String, String> _convertedResults = {};
  String? _converterError;

  // --- Estado de la Calculadora Base-N ---
  String _op1Input = "0";
  String _op2Input = "0";
  NumeralSystem _calculatorSystem = NumeralSystem.binario;
  DigitalOperation _operation = DigitalOperation.add;
  Map<String, String> _calculatorResults = {};
  String? _calculatorError;

  // --- Getters Públicos Explicitados ---
  Map<String, String> get convertedResults => _convertedResults;
  String? get converterError => _converterError;
  NumeralSystem get converterSystem => _converterSystem;

  Map<String, String> get calculatorResults => _calculatorResults;
  String? get calculatorError => _calculatorError;
  NumeralSystem get calculatorSystem => _calculatorSystem;
  DigitalOperation get operation => _operation;

  // --- Lógica del Conversor Universal ---

  /// Actualiza la entrada del conversor y dispara el cálculo síncrono.
  void updateConverterInput(String text, NumeralSystem system) {
    _converterInput = text;
    _converterSystem = system;
    _calculateConversion();
  }

  void _calculateConversion() {
    try {
      _converterError = null;
      if (_converterInput.trim().isEmpty) {
        _convertedResults = {};
        notifyListeners();
        return;
      }

      final target = DigitalNumber.fromString(
        _converterInput,
        _converterSystem,
      );

      _convertedResults = {
        'Binario (Base 2):': target.toSystemString(NumeralSystem.binario),
        'Octal (Base 8):': target.toSystemString(NumeralSystem.octal),
        'Decimal (Base 10):': target.toSystemString(NumeralSystem.decimal),
        'Hexadecimal (Base 16):': target.toSystemString(
          NumeralSystem.hexadecimal,
        ),
      };
      notifyListeners();
    } catch (e) {
      _convertedResults = {};
      _converterError = "Formato inválido para la base seleccionada.";
      notifyListeners();
    }
  }

  // --- Lógica de la Calculadora Base-N ---

  /// Modifica el sistema numérico en el que opera la calculadora.
  void setCalculatorSystem(NumeralSystem system) {
    _calculatorSystem = system;
    _calculateAritmetic();
  }

  /// Modifica la operación aritmética digital a ejecutar.
  void setOperation(DigitalOperation op) {
    _operation = op;
    _calculateAritmetic();
  }

  /// Actualiza los operandos de la calculadora.
  void updateOperands(String op1, String op2) {
    _op1Input = op1;
    _op2Input = op2;
    _calculateAritmetic();
  }

  void _calculateAritmetic() {
    try {
      _calculatorError = null;

      final n1 = DigitalNumber.fromString(
        _op1Input.isEmpty ? "0" : _op1Input,
        _calculatorSystem,
      );
      final n2 = DigitalNumber.fromString(
        _op2Input.isEmpty ? "0" : _op2Input,
        _calculatorSystem,
      );

      DigitalNumber result;
      switch (_operation) {
        case DigitalOperation.add:
          result = n1.add(n2);
          break;
        case DigitalOperation.subtract:
          result = n1.subtract(n2);
          break;
        case DigitalOperation.multiply:
          result = n1.multiply(n2);
          break;
        case DigitalOperation.divide:
          result = n1.divide(n2);
          break;
      }

      // Desplegar el resultado en la base nativa de la operación y en decimal como contraste de ingeniería
      _calculatorResults = {
        'Resultado en Base Nativa (${_calculatorSystem.name.toUpperCase()}):':
            result.toSystemString(_calculatorSystem),
        'Equivalente Decimal (Base 10):': result.toSystemString(
          NumeralSystem.decimal,
        ),
      };
      notifyListeners();
    } catch (e) {
      _calculatorResults = {};
      _calculatorError = e is UnsupportedError
          ? e.message
          : "Error de formato en los operandos.";
      notifyListeners();
    }
  }

  // --- Contrato Formal del Mixin CleanableForm ---
  @override
  void clearForm() {
    // Reseteo de conversión
    _converterInput = "0";
    _convertedResults = {};
    _converterError = null;

    // Reseteo de calculadora
    _op1Input = "0";
    _op2Input = "0";
    _calculatorResults = {};
    _calculatorError = null;

    notifyListeners();
  }
}
