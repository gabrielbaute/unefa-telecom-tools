import 'package:flutter/material.dart';

/// Mixin que añade un contrato formal de limpieza para controladores de formularios.
///
/// Obliga a los controladores que gestionan estados de pantallas limpiables a
/// implementar una rutina para restablecer sus variables internas.
mixin CleanableForm on ChangeNotifier {
  /// Restablece todas las propiedades y estructuras de datos al estado inicial.
  void clearForm();
}
