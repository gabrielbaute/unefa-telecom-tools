import 'package:flutter/material.dart';

/// Tarjeta encargada de mostrar de forma tabular un mapa de resultados llave-valor.
/// Diseñada con disposición vertical para prevenir desbordamientos por strings extensos.
class ResultDisplayCard extends StatelessWidget {
  final Map<String, String> items;

  const ResultDisplayCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Fuerza a que los hijos usen todo el ancho
          children: items.entries.map((entry) {
            final bool isLast = entry.key == items.keys.last;

            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alinea el texto a la izquierda
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Etiqueta identificadora del elemento (ej: "Elemento Z1:")
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Valor numérico/fasorial del resultado
                      Text(
                        entry.value,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          height:
                              1.3, // Mejora el espaciado entre líneas para strings multilínea
                        ),
                      ),
                    ],
                  ),
                ),
                // Agrega un separador intermedio excepto en el último elemento
                if (!isLast)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
