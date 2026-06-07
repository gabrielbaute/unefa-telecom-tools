import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/parallel_controller.dart';
import '../components/custom_segmented_selector.dart';
import '../components/math_text_field.dart';
import '../components/result_display_card.dart';
import '../layouts/base_layout.dart';

class ParallelView extends StatefulWidget {
  const ParallelView({super.key});

  @override
  State<ParallelView> createState() => _ParallelViewState();
}

class _ParallelInputControllers {
  final TextEditingController real;
  final TextEditingController imag;

  _ParallelInputControllers()
    : real = TextEditingController(text: "100"),
      imag = TextEditingController(text: "0");

  void dispose() {
    real.dispose();
    imag.dispose();
  }
}

class _ParallelViewState extends State<ParallelView> {
  final List<_ParallelInputControllers> _branchControllers = [];

  @override
  void dispose() {
    for (var c in _branchControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ParallelController>();

    // Sincronización estricta de controladores de texto locales
    if (_branchControllers.length < controller.realValues.length) {
      while (_branchControllers.length < controller.realValues.length) {
        _branchControllers.add(_ParallelInputControllers());
      }
    } else if (_branchControllers.length > controller.realValues.length) {
      while (_branchControllers.length > controller.realValues.length) {
        _branchControllers.removeLast().dispose();
      }
    }

    final bool isAc = controller.type == ParallelCircuitType.ac;

    return BaseLayout(
      title: 'Equivalentes en Paralelo',
      children: <Widget>[
        // Selector de Dominio (DC / AC) utilizando tu componente abstracto
        CustomSegmentedSelector<ParallelCircuitType>(
          selectedValue: controller.type,
          onSelectionChanged: (newType) => controller.setCircuitType(newType),
          segments: const [
            SelectorSegmentData(
              value: ParallelCircuitType.dc,
              label: 'Corriente Continua (DC)',
              icon: Icons.horizontal_rule,
            ),
            SelectorSegmentData(
              value: ParallelCircuitType.ac,
              label: 'Corriente Alterna (AC)',
              icon: Icons.waves,
            ),
          ],
        ),

        // Cabecera adaptativa con envoltura Expanded para evitar desbordamientos
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isAc
                    ? 'Ramas en Paralelo (Z = R + jX)'
                    : 'Resistencias en Paralelo',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () => controller.addBranch(),
              icon: const Icon(Icons.add),
              label: Text(isAc ? 'Añadir Z' : 'Añadir R'),
            ),
          ],
        ),

        // Renderizado dinámico de las ramas de la red
        ...List.generate(controller.realValues.length, (index) {
          return Row(
            children: [
              Expanded(
                child: MathTextField(
                  label: isAc ? 'R_${index + 1} (Ω)' : 'Rama R${index + 1} (Ω)',
                  hint: '100',
                  controller: _branchControllers[index].real,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => controller.updateBranchValues(
                    index,
                    _branchControllers[index].real.text,
                    _branchControllers[index].imag.text,
                  ),
                ),
              ),
              if (isAc) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: MathTextField(
                    label: 'jX_${index + 1} (Ω)',
                    hint: '0',
                    controller: _branchControllers[index].imag,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    onChanged: (_) => controller.updateBranchValues(
                      index,
                      _branchControllers[index].real.text,
                      _branchControllers[index].imag.text,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: controller.realValues.length > 2
                    ? () {
                        _branchControllers.removeAt(index).dispose();
                        controller.removeBranch(index);
                      }
                    : null,
              ),
            ],
          );
        }),

        if (controller.error != null)
          Text(
            controller.error!,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

        // Muestra el resultado de la reducción de la red
        if (controller.formattedResults.isNotEmpty &&
            controller.error == null) ...[
          Text(
            'Reducción Equivalente Total:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ResultDisplayCard(items: controller.formattedResults),
        ],
      ],
    );
  }
}
