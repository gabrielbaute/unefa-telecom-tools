import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/about_controller.dart';
import '../layouts/base_layout.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  void initState() {
    super.initState();
    // Disparamos la lectura nativa tan pronto como se renderice la vista
    Future.microtask(() => context.read<AboutController>().loadPackageInfo());
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AboutController>();

    return BaseLayout(
      title: 'Acerca de la App',
      children: <Widget>[
        const SizedBox(height: 16),
        // Logo o Icono de la Aplicación
        Center(
          child: Icon(
            Icons.analytics_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        Center(
          child: Text(
            controller.appName,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),

        // Información de Versión dinámica
        Center(
          child: Text(
            'Versión ${controller.version} (Build +${controller.buildNumber})',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        const SizedBox(height: 24),
        const Divider(),

        // Bloque Informativo / Institucional
        Text(
          'Propósito del Proyecto',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'Herramienta de software de código abierto diseñada para el apoyo académico '
          'en los laboratorios de Circuitos, Redes y Radiofrecuencia (RF). '
          'Desarrollada con el fin de promover el acceso libre al conocimiento científico.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
        ),

        const SizedBox(height: 16),

        // Créditos de Desarrollo
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Créditos de Ingeniería',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.code, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Desarrollador: Gabriel',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.school_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Institución: UNEFA',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
