import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/about_controller.dart';
import 'controllers/capacitor_controller.dart';
import 'controllers/complex_controller.dart';
import 'controllers/complex_calc_controller.dart';
import 'controllers/digital_controller.dart';
import 'controllers/divider_controller.dart';
import 'controllers/parallel_controller.dart';
import 'controllers/resistor_controller.dart';
import 'controllers/star_delta_controller.dart';

import 'router/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AboutController()),
        ChangeNotifierProvider(create: (_) => CapacitorController()),
        ChangeNotifierProvider(create: (_) => ComplexController()),
        ChangeNotifierProvider(create: (_) => ComplexCalcController()),
        ChangeNotifierProvider(create: (_) => DigitalController()),
        ChangeNotifierProvider(create: (_) => DividerController()),
        ChangeNotifierProvider(create: (_) => ParallelController()),
        ChangeNotifierProvider(create: (_) => ResistorController()),
        ChangeNotifierProvider(create: (_) => StarDeltaController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el constructor .router para delegar el control a go_router
    return MaterialApp.router(
      title: 'UNEFA Telecom Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router, // Inyección de nuestra configuración
    );
  }
}
