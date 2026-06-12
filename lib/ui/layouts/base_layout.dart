import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';

/// Layout base de toda la aplicación, para centralizar futuros cambios de diseño
/// y mantener una estructura consistente en todas las pantallas.
class BaseLayout extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool showBackButton;
  final List<Widget>? actions; // <-- Parámetro expuesto para las vistas

  const BaseLayout({
    super.key,
    required this.title,
    required this.children,
    this.showBackButton = true,
    this.actions, // Recibe las acciones opcionales
  });

  @override
  Widget build(BuildContext context) {
    const double paddingStandard = 24.0;
    const double spacingBetweenElements = 24.0;

    // Sincronización con GoRouter para evitar el comportamiento nulo de ModalRoute
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final bool isHome = currentRoute == AppRouter.home;

    return Scaffold(
      // PROPAGACIÓN: Enviamos las acciones recibidas de la vista al CustomAppBar
      appBar: CustomAppBar(
        title: title,
        showBackButton: showBackButton,
        actions: actions,
      ),
      drawer: isHome ? const CustomDrawer() : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(paddingStandard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                children
                    .expand(
                      (widget) => [
                        widget,
                        const SizedBox(height: spacingBetweenElements),
                      ],
                    )
                    .toList()
                  ..removeLast(),
          ),
        ),
      ),
    );
  }
}
