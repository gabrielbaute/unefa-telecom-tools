import 'package:flutter/material.dart';
import '../enums/math_enums.dart';
import '../services/trigonometry_service.dart';
import '../mixins/cleanable_form.dart';

/// Controlador avanzado para el laboratorio de Trigonometría.
/// Divide estrictamente el estado de las funciones directas del dominio de las inversas.
class TrigonometryController extends ChangeNotifier with CleanableForm {
  final TrigonometryService _service = TrigonometryService();

  // --- Estado de Funciones Directas e Hiperbólicas ---
  AngleUnit _directUnit = AngleUnit.decimalDegrees;
  String _directMainInput = "0";
  String _dmsDegrees = "0";
  String _dmsMinutes = "0";
  String _dmsSeconds = "0";
  Map<String, String> _directResults = {};
  String? _directError;

  // --- Estado de Funciones Inversas (Arco) ---
  AngleUnit _inverseOutputUnit = AngleUnit.decimalDegrees;
  String _inverseScalarInput = "0";
  Map<String, String> _inverseResults = {};
  String? _inverseError;

  // --- Estado: Funciones Hiperbólicas (Nuevos Canales) ---
  String _hyperbolicScalarInput = "0";
  Map<String, String> _hyperbolicDirectResults = {};
  Map<String, String> _hyperbolicInverseResults = {};
  String? _hyperbolicError;

  // --- Getters Públicos ---
  AngleUnit get directUnit => _directUnit;
  Map<String, String> get directResults => _directResults;
  String? get directError => _directError;

  AngleUnit get inverseOutputUnit => _inverseOutputUnit;
  Map<String, String> get inverseResults => _inverseResults;
  String? get inverseError => _inverseError;

  String get hyperbolicScalarInput => _hyperbolicScalarInput;
  Map<String, String> get hyperbolicDirectResults => _hyperbolicDirectResults;
  Map<String, String> get hyperbolicInverseResults => _hyperbolicInverseResults;
  String? get hyperbolicError => _hyperbolicError;

  // --- Pipeline: Funciones Directas ---
  void setDirectUnit(AngleUnit newUnit) {
    _directUnit = newUnit;
    calculateDirect();
  }

  void updateDirectInput(String value) {
    _directMainInput = value;
    calculateDirect();
  }

  void updateDmsInput(String d, String m, String s) {
    _dmsDegrees = d;
    _dmsMinutes = m;
    _dmsSeconds = s;
    calculateDirect();
  }

  void calculateDirect() {
    try {
      _directError = null;
      double parsedValue = 0.0;

      if (_directUnit == AngleUnit.sexagesimal) {
        final double d =
            double.tryParse(_dmsDegrees.isEmpty ? "0" : _dmsDegrees) ?? 0.0;
        final double m =
            double.tryParse(_dmsMinutes.isEmpty ? "0" : _dmsMinutes) ?? 0.0;
        final double s =
            double.tryParse(_dmsSeconds.isEmpty ? "0" : _dmsSeconds) ?? 0.0;

        if (m < 0 || m >= 60 || s < 0 || s >= 60) {
          throw const FormatException("Minutos/Segundos fuera de rango.");
        }
        parsedValue = d + (m / 60.0) + (s / 3600.0);
      } else {
        parsedValue = double.parse(
          _directMainInput.isEmpty ? "0" : _directMainInput,
        );
      }

      final double rad = _service.convertToRadians(parsedValue, _directUnit);
      final Map<String, double> directRaw = _service.calculateDirect(rad);

      _directResults = {};
      directRaw.forEach((key, val) {
        _directResults[key] = val.isNaN
            ? 'Indeterminado (Asíntota)'
            : val.toStringAsFixed(5);
      });

      notifyListeners();
    } catch (e) {
      _directResults = {};
      _directError = e is FormatException ? e.message : "Error de sintaxis.";
      notifyListeners();
    }
  }

  // --- Pipeline: Funciones Inversas (Arco) ---
  void setInverseOutputUnit(AngleUnit newUnit) {
    _inverseOutputUnit = newUnit;
    calculateInverse();
  }

  void updateInverseInput(String value) {
    _inverseScalarInput = value;
    calculateInverse();
  }

  void calculateInverse() {
    try {
      _inverseError = null;
      final double scalar = double.parse(
        _inverseScalarInput.isEmpty ? "0" : _inverseScalarInput,
      );

      final Map<String, double> inverseRaw = _service.calculateInverse(scalar);
      _inverseResults = {};

      inverseRaw.forEach((key, val) {
        if (val.isNaN) {
          _inverseResults[key] = 'Fuera de dominio [-1, 1]';
        } else {
          final double convertedDegrees = _service.convertFromRadians(
            val,
            AngleUnit.decimalDegrees,
          );

          if (_inverseOutputUnit == AngleUnit.sexagesimal) {
            _inverseResults[key] = _service.formatToSexagesimal(
              convertedDegrees,
            );
          } else if (_inverseOutputUnit == AngleUnit.radians) {
            final double convertedRadians = _service.convertFromRadians(
              val,
              AngleUnit.radians,
            );
            _inverseResults[key] = '${convertedRadians.toStringAsFixed(5)} rad';
          } else {
            _inverseResults[key] = '${convertedDegrees.toStringAsFixed(4)}°';
          }
        }
      });

      notifyListeners();
    } catch (e) {
      _inverseResults = {};
      _inverseError = "Sintaxis numérica errónea.";
      notifyListeners();
    }
  }

  // --- Pipeline: Funciones Hiperbólicas Modernizadas ---
  void updateHyperbolicInput(String value) {
    _hyperbolicScalarInput = value;
    calculateHyperbolic();
  }

  void calculateHyperbolic() {
    try {
      _hyperbolicError = null;
      final double x = double.parse(
        _hyperbolicScalarInput.isEmpty ? "0" : _hyperbolicScalarInput,
      );

      // Despacho simultáneo de los dos bloques analíticos hacia el servicio corregido
      final Map<String, double> directRaw = _service.calculateHyperbolic(x);
      final Map<String, double> inverseRaw = _service
          .calculateInverseHyperbolic(x);

      _hyperbolicDirectResults = {};
      directRaw.forEach((key, val) {
        _hyperbolicDirectResults[key] = val.isNaN
            ? 'Indeterminado'
            : val.toStringAsFixed(5);
      });

      _hyperbolicInverseResults = {};
      inverseRaw.forEach((key, val) {
        _hyperbolicInverseResults[key] = val.isNaN
            ? 'Fuera de dominio real'
            : val.toStringAsFixed(5);
      });

      notifyListeners();
    } catch (e) {
      _hyperbolicDirectResults = {};
      _hyperbolicInverseResults = {};
      _hyperbolicError = "Sintaxis numérica errónea.";
      notifyListeners();
    }
  }

  @override
  void clearForm() {
    _directMainInput = "0";
    _dmsDegrees = "0";
    _dmsMinutes = "0";
    _dmsSeconds = "0";
    _directResults = {};
    _directError = null;

    _inverseScalarInput = "0";
    _inverseResults = {};
    _inverseError = null;

    _hyperbolicScalarInput = "0";
    _hyperbolicDirectResults = {};
    _hyperbolicInverseResults = {};
    _hyperbolicError = null;

    notifyListeners();
  }
}
