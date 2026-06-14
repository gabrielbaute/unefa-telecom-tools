/// Enum para determinar el tipo de operación aritmética en números complejos.
enum ComplexOperation { add, subtract, multiply, divide }

/// Enum para el tipo de representación de un número complejo.
enum ComplexNumMode { rectangular, polar }

/// Enum para definir el sistema de unidades angulares admitido en la suite.
///
/// Attributes:
///      decimalDegrees: Grados decimales (ej. 45.5°)
///      sexagesimal: Grados, Minutos y Segundos (DMS) (ej. 45° 30' 0")
///      radians: Radianes (ej. π/4)
///
enum AngleUnit { decimalDegrees, sexagesimal, radians }
