import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Controlador encargado de leer los metadatos de compilación y versión
/// del sistema operativo para la vista institucional.
class AboutController extends ChangeNotifier {
  String _appName = "Telecom Tools";
  String _version = "1.0.0";
  String _buildNumber = "1";

  String get appName => _appName;
  String get version => _version;
  String get buildNumber => _buildNumber;

  /// Inicializa la lectura asíncrona de los datos del pubspec.yaml
  Future<void> loadPackageInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _appName = packageInfo.appName;
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
      notifyListeners();
    } catch (_) {
      // Si falla (por ejemplo, ejecutándose en web de pruebas), mantiene los valores por defecto
    }
  }
}
