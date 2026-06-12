import 'package:flutter/material.dart';
import '../models/complex_number.dart';
import '../enums/math_enums.dart';
import '../mixins/cleanable_form.dart';

class ComplexCalcController extends ChangeNotifier with CleanableForm {
  ComplexNumMode _mode = ComplexNumMode.rectangular;
  ComplexOperation _operation = ComplexOperation.add;

  // Entradas para Z1
  String _z1RealOrMag = "0";
  String _z1ImagOrAng = "0";

  // Entradas para Z2
  String _z2RealOrMag = "0";
  String _z2ImagOrAng = "0";

  Map<String, String> _formattedResults = {};
  String? _error;

  ComplexNumMode get mode => _mode;
  ComplexOperation get operation => _operation;
  Map<String, String> get formattedResults => _formattedResults;
  String? get error => _error;

  void setMode(ComplexNumMode newMode) {
    _mode = newMode;
    calculate();
  }

  void setOperation(ComplexOperation newOp) {
    _operation = newOp;
    calculate();
  }

  void updateZ1(String v1, String v2) {
    _z1RealOrMag = v1;
    _z1ImagOrAng = v2;
    calculate();
  }

  void updateZ2(String v1, String v2) {
    _z2RealOrMag = v1;
    _z2ImagOrAng = v2;
    calculate();
  }

  void calculate() {
    try {
      _error = null;

      double r1 = double.parse(_z1RealOrMag.isEmpty ? "0" : _z1RealOrMag);
      double i1 = double.parse(_z1ImagOrAng.isEmpty ? "0" : _z1ImagOrAng);
      double r2 = double.parse(_z2RealOrMag.isEmpty ? "0" : _z2RealOrMag);
      double i2 = double.parse(_z2ImagOrAng.isEmpty ? "0" : _z2ImagOrAng);

      // Instanciar los objetos según el modo de entrada seleccionado
      ComplexNumber z1 = _mode == ComplexNumMode.rectangular
          ? ComplexNumber(real: r1, imaginary: i1)
          : ComplexNumber.fromPolar(r1, i1);

      ComplexNumber z2 = _mode == ComplexNumMode.rectangular
          ? ComplexNumber(real: r2, imaginary: i2)
          : ComplexNumber.fromPolar(r2, i2);

      ComplexNumber result;

      // Despachar la operación matemática formal encapsulada en el modelo
      switch (_operation) {
        case ComplexOperation.add:
          result = z1.add(z2);
          break;
        case ComplexOperation.subtract:
          result = z1.subtract(z2);
          break;
        case ComplexOperation.multiply:
          result = z1.multiply(z2);
          break;
        case ComplexOperation.divide:
          result = z1.divide(z2);
          break;
      }

      String sign = result.imaginary >= 0 ? '+' : '-';
      _formattedResults = {
        'Resultado en Forma Rectangular:':
            '${result.real.toStringAsFixed(3)} $sign j${result.imaginary.abs().toStringAsFixed(3)}',
        'Resultado en Forma Fasorial:':
            '${result.magnitude.toStringAsFixed(3)} ∡ ${result.phaseDegrees.toStringAsFixed(2)}°',
      };
      notifyListeners();
    } catch (e) {
      _formattedResults = {};
      if (e.toString().contains("DivideByZeroException")) {
        _error = "Error: Indeterminación por división entre cero.";
      } else {
        _error = "Ingrese valores numéricos válidos";
      }
      notifyListeners();
    }
  }

  @override
  void clearForm() {
    _z1RealOrMag = "0";
    _z1ImagOrAng = "0";
    _z2RealOrMag = "0";
    _z2ImagOrAng = "0";
    _formattedResults = {};
    _error = null;
    notifyListeners();
  }
}
