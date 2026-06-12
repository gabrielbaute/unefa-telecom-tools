import 'package:flutter/material.dart';
import '../models/complex_number.dart';
import '../services/complex_math_service.dart';
import '../enums/circuit_enums.dart';

class StarDeltaController extends ChangeNotifier {
  final ComplexMathService _mathService = ComplexMathService();

  ConversionDirection _direction = ConversionDirection.deltaToWye;
  CircuitDomain _domain = CircuitDomain.dc;

  // Valores de los 3 componentes de entrada (Parte Real e Imaginaria)
  final List<String> _realInputs = ["100", "100", "100"];
  final List<String> _imagInputs = ["0", "0", "0"];

  Map<String, String> _formattedResults = {};
  String? _error;

  ConversionDirection get direction => _direction;
  CircuitDomain get domain => _domain;
  Map<String, String> get formattedResults => _formattedResults;
  String? get error => _error;

  /// Establece la dirección de la conversión entre circuitos.
  void setDirection(ConversionDirection newDir) {
    _direction = newDir;
    calculate();
  }

  /// Establece el dominio de frecuencia (DC / AC).
  void setCircuitDomian(CircuitDomain newDomain) {
    _domain = newDomain;
    calculate();
  }

  /// Actualiza los valores de entrada en el controlador.
  void updateInput(int index, String real, String imag) {
    _realInputs[index] = real;
    _imagInputs[index] = imag;
    calculate();
  }

  /// Efectúa el cálculo de números complejos para relizar la conversión.
  void calculate() {
    try {
      _error = null;
      List<ComplexNumber> inputs = [];

      for (int i = 0; i < 3; i++) {
        double r = double.parse(_realInputs[i].isEmpty ? "0" : _realInputs[i]);
        double x = double.parse(_imagInputs[i].isEmpty ? "0" : _imagInputs[i]);
        if (_domain == CircuitDomain.dc && r <= 0)
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

  /// Formatea los resultados de salida.
  void _formatOutputResults(List<ComplexNumber> outputs) {
    _formattedResults = {};
    bool isDeltaToWye = _direction == ConversionDirection.deltaToWye;
    List<String> labels = isDeltaToWye
        ? ['Z₁ (Estrella)', 'Z₂ (Estrella)', 'Z₃ (Estrella)']
        : ['Z_A (Delta)', 'Z_B (Delta)', 'Z_C (Delta)'];
    String unit = _domain == CircuitDomain.dc ? 'Ω' : 'Ω';

    for (int i = 0; i < 3; i++) {
      ComplexNumber z = outputs[i];
      if (_domain == CircuitDomain.dc) {
        _formattedResults[labels[i]] = '${z.real.toStringAsFixed(3)} $unit';
      } else {
        String sign = z.imaginary >= 0 ? '+' : '-';
        _formattedResults[labels[i]] =
            '${z.real.toStringAsFixed(2)} $sign j${z.imaginary.abs().toStringAsFixed(2)} $unit\n'
            '(${z.magnitude.toStringAsFixed(2)} ∡ ${z.phaseDegrees.toStringAsFixed(1)}° $unit)';
      }
    }
  }

  /// Restablece todas las entradas y mapas de resultados a su estado inicial.
  void clearForm() {
    for (int i = 0; i < 3; i++) {
      _realInputs[i] = "100";
      _imagInputs[i] = "0";
    }
    _formattedResults = {};
    _error = null;
    notifyListeners(); // Notifica a la UI para vaciar los campos
  }
}
