import 'package:flutter/material.dart';
import '../mixins/cleanable_form.dart';
import '../services/ceramic_capacitor_service.dart';

class CapacitorController extends ChangeNotifier with CleanableForm {
  final CeramicCapacitorService _service = CeramicCapacitorService();

  String _code = "";
  Map<String, dynamic>? _result;
  String? _error;

  Map<String, dynamic>? get result => _result;
  String? get error => _error;

  void updateCode(String value) {
    _code = value;
    _decode();
  }

  void _decode() {
    if (_code.length < 3) {
      _result = null;
      _error = "Mínimo 3 dígitos";
      notifyListeners();
      return;
    }

    try {
      _result = _service.decodeCode(_code);
      _error = null;
    } catch (e) {
      _result = null;
      _error = "Código inválido";
    }
    notifyListeners();
  }

  @override
  void clearForm() {
    _code = "";
    _result = null;
    _error = null;
    notifyListeners();
  }
}
