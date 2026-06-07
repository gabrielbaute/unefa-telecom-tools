import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Importante para usar context.pop()

/// Un AppBar personalizado y homogeneizado para las pantallas de la aplicación.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              // Usamos context.pop() de go_router para retirar la vista de la pila de forma segura
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
