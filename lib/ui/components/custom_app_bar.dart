import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Un AppBar personalizado y homogeneizado para las pantallas de la aplicación.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>?
  actions; // <-- NUEVO: Parámetro para inyectar botones a la derecha

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      actions:
          actions, // <-- INYECCIÓN NATIVA: Despliega los widgets en el extremo derecho
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
