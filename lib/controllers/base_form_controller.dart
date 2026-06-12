import 'package:flutter/material.dart';

/// Clase abstracta que define el contrato obligatorio para los
/// controladores que gestionan datos de formularios limpiables.
abstract class BaseFormController extends ChangeNotifier {
  /// Restablece las variables de estado internas a sus valores por defecto.
  void clearForm();
}
