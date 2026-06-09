import 'package:flutter/material.dart';
import '../models/complex_number.dart';
import '../services/complex_math_service.dart';

enum ConversionDirection { deltaToWye, wyeToDelta }

enum NetworkCircuitType { dc, ac }

class StarDeltaController extends ChangeNotifier {
  final ComplexMathService _mathService = ComplexMathService();

  ConversionDirection _direction = ConversionDirection.deltaToWye;
  NetworkCircuitType _type = NetworkCircuitType.dc;

  // Valores de los 3 componentes de entrada (Parte Real e Imaginaria)
  final List<String> _realInputs = ["100", "100", "100"];
  final List<String> _imagInputs = ["0", "0", "0"];

  Map<String, String> _formattedResults = {};
  String? _error;

  ConversionDirection get direction => _direction;
  NetworkCircuitType get type => _type;
  Map<String, String> get formattedResults => _formattedResults;
  String? get error => _error;

  void setDirection(ConversionDirection newDir) {
    _direction = newDir;
    calculate();
  }

  void setCircuitType(NetworkCircuitType newType) {
    _type = newType;
    calculate();
  }

  void updateInput(int index, String real, String imag) {
    _realInputs[index] = real;
    _imagInputs[index] = imag;
    calculate();
  }

  void calculate() {
    try {
      _error = null;
      List<ComplexNumber> inputs = [];

      for (int i = 0; i < 3; i++) {
        double r = double.parse(_realInputs[i].isEmpty ? "0" : _realInputs[i]);
        double x = double.parse(_imagInputs[i].isEmpty ? "0" : _imagInputs[i]);
        if (_type == NetworkCircuitType.dc && r <= 0)
          throw const FormatException();
        inputs.add(ComplexNumber(real: r, imaginary: x));
      }

      List<ComplexNumber> outputs = _direction == ConversionDirection.deltaToWye
          ? _mathService.deltaToWye(inputs[0], inputs[1], inputs[2])
          : _mathService.wyeToDelta(inputs[0], inputs[1], inputs[2]);

      _formatOutputResults(outputs);
      notifyListeners();
    } catch (e) {
      _formattedResults = {};
      _error = "Verifique que las magnitudes sean numéricas y mayores a cero.";
      notifyListeners();
    }
  }

  void _formatOutputResults(List<ComplexNumber> outputs) {
    _formattedResults = {};
    bool isDeltaToWye = _direction == ConversionDirection.deltaToWye;
    List<String> labels = isDeltaToWye
        ? ['Z₁ (Estrella)', 'Z₂ (Estrella)', 'Z₃ (Estrella)']
        : ['Z_A (Delta)', 'Z_B (Delta)', 'Z_C (Delta)'];
    String unit = _type == NetworkCircuitType.dc ? 'Ω' : 'Ω';

    for (int i = 0; i < 3; i++) {
      ComplexNumber z = outputs[i];
      if (_type == NetworkCircuitType.dc) {
        _formattedResults[labels[i]] = '${z.real.toStringAsFixed(3)} $unit';
      } else {
        String sign = z.imaginary >= 0 ? '+' : '-';
        _formattedResults[labels[i]] =
            '${z.real.toStringAsFixed(2)} $sign j${z.imaginary.abs().toStringAsFixed(2)} $unit\n'
            '(${z.magnitude.toStringAsFixed(2)} ∡ ${z.phaseDegrees.toStringAsFixed(1)}° $unit)';
      }
    }
  }
}
