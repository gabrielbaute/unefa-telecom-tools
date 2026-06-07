import 'package:flutter/material.dart';
import '../../router/app_router.dart';

/// Menú lateral exclusivo para la gestión administrativa de la aplicación
/// (Configuraciones, Temas, Versión y Soporte Institucional).
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return NavigationDrawer(
      selectedIndex: _calculateSelectedIndex(currentRoute),
      onDestinationSelected: (int index) {
        Navigator.pop(context); // Cierra el menú lateral antes de la transición
        _handleNavigation(context, index, currentRoute);
      },
      children: <Widget>[
        // Encabezado del Drawer
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Telecom Tools',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Gestión y Soporte',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const Divider(indent: 16, endIndent: 16),

        // Destino 0: Retornar al Tablero Principal de Herramientas
        const NavigationDrawerDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Tablero de Cálculo'),
        ),

        // Destino 1: Secciones Informativas e Institucionales
        const NavigationDrawerDestination(
          icon: Icon(Icons.info_outline),
          selectedIcon: Icon(Icons.info),
          label: Text('Acerca de la App'),
        ),

        /* A FUTURO: Aquí agregarás el destino para la configuración de temas
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Configuración'),
        ),
        */
      ],
    );
  }

  /// Mapea de forma simplificada las rutas a los índices del Drawer administrativo.
  int _calculateSelectedIndex(String? currentRoute) {
    switch (currentRoute) {
      case AppRouter.home:
        return 0;
      case AppRouter.about:
        return 1;
      default:
        return 0; // Si está dentro de cualquier herramienta de cálculo, resalta el Tablero
    }
  }

  /// Ejecuta las transiciones manteniendo la jerarquía limpia.
  void _handleNavigation(
    BuildContext context,
    int index,
    String? currentRoute,
  ) {
    String targetRoute = AppRouter.home;

    switch (index) {
      case 0:
        targetRoute = AppRouter.home;
        break;
      case 1:
        targetRoute = AppRouter.about;
        break;
    }

    if (currentRoute != targetRoute) {
      if (targetRoute == AppRouter.home) {
        // Al volver al Home, limpiamos el historial para que sea la base de la pila
        Navigator.pushNamedAndRemoveUntil(
          context,
          targetRoute,
          (route) => false,
        );
      } else {
        Navigator.pushNamed(context, targetRoute);
      }
    }
  }
}
