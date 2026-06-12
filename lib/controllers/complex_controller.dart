import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/complex_converter_service.dart';
import '../enums/math_enums.dart';

class ComplexController extends ChangeNotifier {
  final ComplexConverterService _service = ComplexConverterService();

  ComplexNumMode _inputMode = ComplexNumMode.rectangular;

  // Variables de entrada
  String _val1 = "0"; // Representa Real o Magnitud
  String _val2 = "0"; // Representa Imaginario o Fase (Grados)

  Map<String, dynamic>? _result;
  String? _error;

  ComplexNumMode get inputMode => _inputMode;
  Map<String, dynamic>? get result => _result;
  String? get error => _error;

  void setInputMode(ComplexNumMode mode) {
    _inputMode = mode;
    _val1 = "0";
    _val2 = "0";
    _result = null;
    _error = null;
    notifyListeners();
  }

  void updateValues(String v1, String v2) {
    _val1 = v1.isEmpty ? "0" : v1;
    _val2 = v2.isEmpty ? "0" : v2;
    calculate();
  }

  void calculate() {
    try {
      double p1 = double.parse(_val1);
      double p2 = double.parse(_val2);
      _error = null;

      if (_inputMode == ComplexNumMode.rectangular) {
        final polars = _service.fromRectangular(p1, p2);
        _result = {
          'real': p1,
          'imaginary': p2,
          'magnitude': polars['magnitude'],
          'phaseDegrees': polars['phaseDegrees'],
          'phaseRadians': polars['phaseRadians'],
        };
      } else {
        final rects = _service.fromFasorial(p1, p2);
        _result = {
          'real': rects['real'],
          'imaginary': rects['imaginary'],
          'magnitude': p1,
          'phaseDegrees': p2,
          'phaseRadians': p2 * (math.pi / 180.0),
        };
      }
      notifyListeners();
    } catch (e) {
      _result = null;
      _error = "Ingrese valores numéricos válidos";
      notifyListeners();
    }
  }
}
