import 'package:flutter/material.dart';
import 'package:ihc_app/screens/main_screen.dart'; 

void main() {
  runApp(const GroceryApp());
}

// Widget principal que define el tema de la aplicación
class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supermercado Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Color base verde
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade700),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}