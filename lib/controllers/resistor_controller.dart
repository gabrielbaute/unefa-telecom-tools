import 'package:flutter/material.dart';
import '../enums/resist_color_enum.dart';
import '../services/resistor_calculator_service.dart';

class ResistorController extends ChangeNotifier {
  final ResistorCalculatorService _service = ResistorCalculatorService();

  // Estado: Bandas seleccionadas (por defecto 4 bandas)
  final List<ResistorColor> _selectedBands = [
    ResistorColor.brown,
    ResistorColor.black,
    ResistorColor.red,
    ResistorColor.gold,
  ];

  Map<String, dynamic>? _result;

  // Getters para la UI
  List<ResistorColor> get selectedBands => _selectedBands;
  Map<String, dynamic>? get result => _result;

  void updateBand(int index, ResistorColor newColor) {
    _selectedBands[index] = newColor;
    calculate();
  }

  void calculate() {
    try {
      _result = _service.calculateValue(_selectedBands);
      notifyListeners(); // Esto "avisa" a la UI que debe redibujarse
    } catch (e) {
      _result = null;
      notifyListeners();
    }
  }
}
