import 'package:flutter/material.dart';
import '../models/complex_number.dart';
import '../enums/circuit_enums.dart';
import '../mixins/cleanable_form.dart';
import '../services/complex_math_service.dart';
import '../services/divider_calculator_service.dart';

class DividerController extends ChangeNotifier with CleanableForm {
  final DividerCalculatorService _dcService = DividerCalculatorService();
  final ComplexMathService _acService = ComplexMathService();

  CircuitMagnitude _magnitude = CircuitMagnitude.voltage;
  CircuitDomain _domain = CircuitDomain.dc; // Por defecto iniciamos en DC

  String _sourceValueReal = "12";
  String _sourceValueImag = "0"; // Para la fuente en AC

  // Listas dinámicas para capturar las entradas de la red
  final List<String> _realValues = ["100", "100"];
  final List<String> _imagValues = ["0", "0"];

  // Resultados formateados listos para la interfaz
  Map<String, String> _formattedResults = {};
  String? _error;

  CircuitMagnitude get mode => _magnitude;
  CircuitDomain get domain => _domain;
  List<String> get realValues => _realValues;
  List<String> get imagValues => _imagValues;
  Map<String, String> get formattedResults => _formattedResults;
  String? get error => _error;
  String get sourceValueReal => _sourceValueReal;
  String get sourceValueImag => _sourceValueImag;

  /// Determina la magnitud con la que se va a trabajar: corriente o voltaje
  void setMode(CircuitMagnitude newMagnitude) {
    _magnitude = newMagnitude;
    calculate();
  }

  void setCircuitDomian(CircuitDomain newDomain) {
    _domain = newDomain;
    calculate();
  }

  void updateSource(String real, String imag) {
    _sourceValueReal = real;
    _sourceValueImag = imag;
    calculate();
  }

  void addElement() {
    _realValues.add("100");
    _imagValues.add("0");
    calculate();
  }

  void removeElement(int index) {
    if (_realValues.length > 2) {
      _realValues.removeAt(index);
      _imagValues.removeAt(index);
      calculate();
    }
  }

  void updateElementValues(int index, String real, String imag) {
    _realValues[index] = real;
    _imagValues[index] = imag;
    calculate();
  }

  void calculate() {
    try {
      _error = null;
      double sReal = double.parse(
        _sourceValueReal.isEmpty ? "0" : _sourceValueReal,
      );
      double sImag = double.parse(
        _sourceValueImag.isEmpty ? "0" : _sourceValueImag,
      );

      if (_domain == CircuitDomain.dc) {
        _executeDcCalculation(sReal);
      } else {
        _executeAcCalculation(sReal, sImag);
      }
      notifyListeners();
    } catch (e) {
      _formattedResults = {};
      _error = "Ingrese únicamente valores numéricos válidos";
      notifyListeners();
    }
  }

  /// Ejecuta el pipeline clásico para resistencias puras (Números Reales)
  void _executeDcCalculation(double source) {
    List<double> rList = _realValues
        .map((v) => double.parse(v.isEmpty ? "0" : v))
        .toList();
    if (rList.any((r) => r < 0)) throw const FormatException();

    List<double> rawResults = _magnitude == CircuitMagnitude.voltage
        ? _dcService.calculateVoltageDivider(source, rList)
        : _dcService.calculateCurrentDivider(source, rList);

    String unit = _magnitude == CircuitMagnitude.voltage ? 'V' : 'A';
    _formattedResults = {};
    for (int i = 0; i < rawResults.length; i++) {
      _formattedResults['Elemento R${i + 1}:'] =
          '${rawResults[i].toStringAsFixed(3)} $unit';
    }
  }

  /// Ejecuta el pipeline avanzado para impedancias (Números Complejos)
  void _executeAcCalculation(double sourceReal, double sourceImag) {
    ComplexNumber vIn = ComplexNumber(real: sourceReal, imaginary: sourceImag);

    List<ComplexNumber> zList = [];
    for (int i = 0; i < _realValues.length; i++) {
      double r = double.parse(_realValues[i].isEmpty ? "0" : _realValues[i]);
      double x = double.parse(_imagValues[i].isEmpty ? "0" : _imagValues[i]);
      zList.add(ComplexNumber(real: r, imaginary: x));
    }

    List<ComplexNumber> rawResults = _magnitude == CircuitMagnitude.voltage
        ? _acService.calculateVoltageDivider(vIn, zList)
        : _acService.calculateCurrentDivider(vIn, zList);

    String unit = _magnitude == CircuitMagnitude.voltage ? 'V' : 'A';
    _formattedResults = {};
    for (int i = 0; i < rawResults.length; i++) {
      ComplexNumber z = rawResults[i];
      String sign = z.imaginary >= 0 ? '+' : '-';

      // Entregamos el resultado tanto en fasor como en rectangular para comodidad del alumno
      _formattedResults['Elemento Z${i + 1}:'] =
          '${z.real.toStringAsFixed(2)} $sign j${z.imaginary.abs().toStringAsFixed(2)} $unit\n'
          '(${z.magnitude.toStringAsFixed(2)} ∡ ${z.phaseDegrees.toStringAsFixed(1)}° $unit)';
    }
  }

  @override
  void clearForm() {
    _sourceValueReal = "12";
    _sourceValueImag = "0";

    // Al ser dinámico, preservamos los dos elementos mínimos iniciales
    _realValues.clear();
    _imagValues.clear();
    _realValues.addAll(["100", "100"]);
    _imagValues.addAll(["0", "0"]);

    _formattedResults = {};
    _error = null;
    notifyListeners();
  }
}
