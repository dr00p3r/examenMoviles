import 'package:flutter/material.dart';
import 'package:mandilon_ventas/ui/sales_overview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Examen Final Mandilón Ventas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan.shade300),
      ),
      home: const SalesOverviewPage(),
    );
  }
}