import 'package:flutter/material.dart';
import '../../router/app_router.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';

/// Layout base de toda la aplicación, para centralizar futuros cambios de diseño
/// y mantener una estructura consistente en todas las pantallas.
class BaseLayout extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool showBackButton; // Parámetro propagado para la raíz

  const BaseLayout({
    super.key,
    required this.title,
    required this.children,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    const double paddingStandard = 24.0;
    const double spacingBetweenElements = 24.0;

    // Determina si se muestra el Drawer solo en la pantalla principal (Tablero)
    // Si no es la pantalla principal, se oculta el Drawer y se muestra el botón de retroceso
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final bool isHome = currentRoute == AppRouter.home;

    // Scaffold con AppBar personalizado, Drawer condicional y cuerpo con scroll y padding estándar
    return Scaffold(
      appBar: CustomAppBar(title: title, showBackButton: showBackButton),
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
