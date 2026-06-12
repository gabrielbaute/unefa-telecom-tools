import 'package:flutter/material.dart';
import '../enums/circuit_enums.dart';
import '../models/complex_number.dart';
import '../services/complex_math_service.dart';

class ParallelController extends ChangeNotifier {
  final ComplexMathService _acService = ComplexMathService();

  CircuitDomain _domain = CircuitDomain.dc;

  // Listas dinámicas para capturar los valores de las ramas
  final List<String> _realValues = ["100", "100"];
  final List<String> _imagValues = ["0", "0"];

  Map<String, String> _formattedResults = {};
  String? _error;

  CircuitDomain get domain => _domain;
  List<String> get realValues => _realValues;
  List<String> get imagValues => _imagValues;
  Map<String, String> get formattedResults => _formattedResults;
  String? get error => _error;

  void setCircuitDomain(CircuitDomain newDomain) {
    _domain = newDomain;
    calculate();
  }

  void addBranch() {
    _realValues.add("100");
    _imagValues.add("0");
    calculate();
  }

  void removeBranch(int index) {
    if (_realValues.length > 2) {
      _realValues.removeAt(index);
      _imagValues.removeAt(index);
      calculate();
    }
  }

  void updateBranchValues(int index, String real, String imag) {
    _realValues[index] = real;
    _imagValues[index] = imag;
    calculate();
  }

  void calculate() {
    try {
      _error = null;

      if (_domain == CircuitDomain.dc) {
        _executeDcParallel();
      } else {
        _executeAcParallel();
      }
      notifyListeners();
    } catch (e) {
      _formattedResults = {};
      _error = "Ingrese valores numéricos válidos (mayores a cero)";
      notifyListeners();
    }
  }

  void _executeDcParallel() {
    List<double> rList = _realValues
        .map((v) => double.parse(v.isEmpty ? "0" : v))
        .toList();
    if (rList.any((r) => r <= 0)) throw const FormatException();

    // Reutilizamos el cálculo de conductancia equivalente: R_eq = 1 / Σ(1/Ri)
    double gEq = rList.fold(0.0, (sum, r) => sum + (1.0 / r));
    double rEq = 1.0 / gEq;

    _formattedResults = {
      'Resistencia Equivalente Total (R_eq):': '${rEq.toStringAsFixed(3)} Ω',
    };
  }

  void _executeAcParallel() {
    List<ComplexNumber> zList = [];
    for (int i = 0; i < _realValues.length; i++) {
      double r = double.parse(_realValues[i].isEmpty ? "0" : _realValues[i]);
      double x = double.parse(_imagValues[i].isEmpty ? "0" : _imagValues[i]);
      if (r == 0 && x == 0) throw const FormatException();
      zList.add(ComplexNumber(real: r, imaginary: x));
    }

    ComplexNumber zEq = _acService.calculateParallelEquivalent(zList);
    String sign = zEq.imaginary >= 0 ? '+' : '-';

    _formattedResults = {
      'Impedancia Equivalente (Z_eq):':
          '${zEq.real.toStringAsFixed(3)} $sign j${zEq.imaginary.abs().toStringAsFixed(3)} Ω\n'
          '(${zEq.magnitude.toStringAsFixed(3)} ∡ ${zEq.phaseDegrees.toStringAsFixed(1)}° Ω)',
    };
  }
}
