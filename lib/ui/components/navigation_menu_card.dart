import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tarjeta estandarizada para el menú principal que gestiona la redirección
/// hacia los diferentes módulos de cálculo mediante go_router.
class NavigationMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String routePath;

  const NavigationMenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets
          .zero, // El margen se delega al contenedor o layout superior
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Usamos context.push para apilar la vista manteniendo el Home debajo
          context.push(routePath);
        },
      ),
    );
  }
}
