import 'package:flutter/material.dart';
import '../../router/app_router.dart';
import '../components/navigation_menu_card.dart';
import '../layouts/base_layout.dart';

/// Pantalla principal que actúa como menú de navegación para las herramientas disponibles.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayout(
      title: 'UNEFA Telecom Tools',
      showBackButton: false, // Oculta el botón por ser la pantalla raíz
      children: <Widget>[
        // SECCIÓN DE REDES ELÉCTRICAS
        Text(
          'Cálculos Electrónicos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        // Módulo de Resistencias abstracto
        NavigationMenuCard(
          title: 'Código de Colores de Resistencias',
          subtitle: 'Calcular valor en Ohmios (4 y 5 bandas)',
          icon: Icons.tune,
          routePath: AppRouter.resistor,
        ),

        // Módulo de Condensadores abstracto
        NavigationMenuCard(
          title: 'Código de Condensadores Cerámicos',
          subtitle: 'Decodificar marcado a Faradios y picofaradios',
          icon: Icons.animation,
          routePath: AppRouter.capacitor,
        ),

        // Módulo de Números Complejos abstracto
        NavigationMenuCard(
          title: 'Conversor de Fasores',
          subtitle: 'Transformación rectangular, fasorial y exponencial',
          icon: Icons.grid_3x3,
          routePath: AppRouter.complex,
        ),

        // Módulo de Divisores abstracto
        NavigationMenuCard(
          title: 'Divisores Dinámicos',
          subtitle:
              'Calcular voltajes y corrientes en divisores de resistencias',
          icon: Icons.settings_input_component,
          routePath: AppRouter.divider,
        ),

        // Módulo de Paralelos abstracto
        NavigationMenuCard(
          title: 'Paralelos Dinámicos',
          subtitle:
              'Calcular equivalentes en paralelo para resistencias y fasores',
          icon: Icons.waves,
          routePath: AppRouter.parallel,
        ),

        // SECCIÓN DE MATEMÁTICAS
        Text(
          'Cálculos Matemáticos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Módulo de Aritmética Compleja abstracto
        NavigationMenuCard(
          title: 'Calculadora de Aritmética Compleja',
          subtitle: 'Suma, resta, multiplicación y división de complejos',
          icon: Icons.calculate,
          routePath: AppRouter.complexCalc,
        ),
      ],
    );
  }
}
