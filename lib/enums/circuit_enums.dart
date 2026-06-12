/// Enum para determinar la dirección de la conversión entre circuitos de estrella y delta.
enum ConversionDirection { deltaToWye, wyeToDelta }

/// Enum para determinar el tipo de circuito de red: DC o AC.
enum CircuitDomain { dc, ac }

/// Enum para el tipo de magnitud con el que se va a operar el circuito.
enum CircuitMagnitude { voltage, current, resistance }
