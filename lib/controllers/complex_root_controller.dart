import 'package:flutter/material.dart';
import '../enums/math_enums.dart';
import '../models/complex_number.dart';
import '../mixins/cleanable_form.dart';
import '../services/complex_root_service.dart';

/// Controlador para la gestión de estados y cálculos del módulo de Raíces Complejas.
class ComplexRootController extends ChangeNotifier with CleanableForm {
  final ComplexRootService _service = ComplexRootService();

  ComplexNumMode _mode = ComplexNumMode.rectangular;
  String _val1 = "0"; // Real (rectangular) o Magnitud (polar)
  String _val2 = "0"; // Imaginario (rectangular) o Ángulo en grados (polar)
  String _rootOrderInput = "2"; // Orden de la raíz (n)

  Map<String, String> _formattedResults = {};
  String? _error;

  // --- Getters Públicos ---
  ComplexNumMode get mode => _mode;
  String get val1 => _val1;
  String get val2 => _val2;
  String get rootOrderInput => _rootOrderInput;
  Map<String, String> get formattedResults => _formattedResults;
  String? get error => _error;

  /// Cambia el modo de entrada (Rectangular / Polar).
  ///
  /// Args:
  ///   [newMode] (ComplexNumMode): El nuevo modo seleccionado.
  void setMode(ComplexNumMode newMode) {
    _mode = newMode;
    calculate();
  }

  /// Actualiza los valores del número complejo Z.
  ///
  /// Args:
  ///   [v1] (String): Primer parámetro de entrada.
  ///   [v2] (String): Segundo parámetro de entrada.
  void updateComplexValues(String v1, String v2) {
    _val1 = v1;
    _val2 = v2;
    calculate();
  }

  /// Actualiza el orden de la raíz (n).
  ///
  /// Args:
  ///   [order] (String): Orden de la raíz en formato de texto.
  void updateRootOrder(String order) {
    _rootOrderInput = order;
    calculate();
  }

  /// Ejecuta el pipeline de cálculo de raíces complejas.
  void calculate() {
    try {
      _error = null;

      final double p1 = double.parse(_val1.isEmpty ? "0" : _val1);
      final double p2 = double.parse(_val2.isEmpty ? "0" : _val2);
      final int n = int.parse(_rootOrderInput.isEmpty ? "2" : _rootOrderInput);

      if (n < 1) {
        throw ArgumentError('El orden de la raíz debe ser mayor o igual a 1.');
      }

      // Instanciar el número complejo según el modo de entrada seleccionado
      final ComplexNumber z = _mode == ComplexNumMode.rectangular
          ? ComplexNumber(real: p1, imaginary: p2)
          : ComplexNumber.fromPolar(p1, p2);

      // Calcular las raíces usando el servicio
      final List<ComplexNumber> roots = _service.calculateNthRoots(z, n);

      _formattedResults = {};
      for (int i = 0; i < roots.length; i++) {
        final ComplexNumber root = roots[i];
        final String sign = root.imaginary >= 0 ? '+' : '-';

        _formattedResults['Raíz W_${i + 1}:'] =
            '${root.real.toStringAsFixed(3)} $sign j${root.imaginary.abs().toStringAsFixed(3)}\n'
            '(${root.magnitude.toStringAsFixed(3)} ∡ ${root.phaseDegrees.toStringAsFixed(2)}°)';
      }

      notifyListeners();
    } catch (e) {
      _formattedResults = {};
      _error = e is ArgumentError
          ? e.message
          : 'Ingrese valores numéricos válidos.';
      notifyListeners();
    }
  }

  /// Restablece todas las propiedades del formulario a su estado inicial.
  @override
  void clearForm() {
    _val1 = "0";
    _val2 = "0";
    _rootOrderInput = "2";
    _formattedResults = {};
    _error = null;
    notifyListeners();
  }
}
