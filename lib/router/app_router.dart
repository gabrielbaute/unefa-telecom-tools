import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/views/home_view.dart';
import '../ui/views/about_view.dart';
import '../ui/views/capacitor_view.dart';
import '../ui/views/complex_calc_view.dart';
import '../ui/views/complex_view.dart';
import '../ui/views/digital_calculator_view.dart';
import '../ui/views/digital_converter_view.dart';
import '../ui/views/divider_view.dart';
import '../ui/views/parallel_view.dart';
import '../ui/views/resistor_view.dart';
import '../ui/views/star_delta_view.dart';

/// Configuración centralizada del enrutamiento de la aplicación.
///
/// Define las rutas disponibles, sus nombres y los mapeos hacia las vistas.
class AppRouter {
  // Nombres de las rutas como constantes estáticas para evitar errores de tipeo
  static const String home = '/';
  static const String about = '/about';
  static const String resistor = '/resistor';
  static const String capacitor = '/capacitor';
  static const String complex = '/complex';
  static const String divider = '/divider';
  static const String parallel = '/parallel';
  static const String complexCalc = '/complex-calc';
  static const String starDelta = '/star-delta';
  static const String digitalConverter = '/digital-converter';
  static const String digitalCalculator = '/digital-calculator';

  /// Instancia principal de GoRouter que maneja la navegación.
  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: <RouteBase>[
      GoRoute(
        path: home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeView();
        },
      ),
      GoRoute(
        path: about,
        builder: (BuildContext context, GoRouterState state) {
          return const AboutView();
        },
      ),
      GoRoute(
        path: resistor,
        builder: (BuildContext context, GoRouterState state) {
          return const ResistorView();
        },
      ),
      GoRoute(
        path: capacitor,
        builder: (BuildContext context, GoRouterState state) {
          return const CapacitorView();
        },
      ),
      GoRoute(
        path: complex,
        builder: (BuildContext context, GoRouterState state) {
          return const ComplexView();
        },
      ),
      GoRoute(
        path: divider,
        builder: (BuildContext context, GoRouterState state) {
          return const DividerView();
        },
      ),
      GoRoute(
        path: parallel,
        builder: (BuildContext context, GoRouterState state) {
          return const ParallelView();
        },
      ),
      GoRoute(
        path: complexCalc,
        builder: (BuildContext context, GoRouterState state) {
          return const ComplexCalcView();
        },
      ),
      GoRoute(
        path: starDelta,
        builder: (BuildContext context, GoRouterState state) {
          return const StarDeltaView();
        },
      ),
      GoRoute(
        path: digitalConverter,
        builder: (BuildContext context, GoRouterState state) {
          return const DigitalConverterView();
        },
      ),
      GoRoute(
        path: digitalCalculator,
        builder: (BuildContext context, GoRouterState state) {
          return const DigitalCalculatorView();
        },
      ),
    ],

    // Mapeo opcional para errores de enrutamiento (404)
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
  );
}
