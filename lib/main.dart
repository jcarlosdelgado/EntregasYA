import 'package:flutter/material.dart';
import 'package:ihc_app/screens/main_screen.dart'; 
import 'package:ihc_app/screens/animation/splashScreen.dart';
import 'package:ihc_app/screens/main_screen.dart';
import 'package:ihc_app/screens/cart_screen.dart';
import 'package:ihc_app/screens/payment_screen.dart';
import 'package:ihc_app/screens/delivery_tracking_screen.dart';
import 'package:ihc_app/screens/order_completed_screen.dart';
import 'package:ihc_app/screens/order_history_screen.dart';
import 'package:ihc_app/screens/rating_screen.dart';
import 'package:ihc_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar el servicio de notificaciones
  await NotificationService().initialize();

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
        // Esquema de colores naranja y blanco
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35), // Naranja principal
          brightness: Brightness.light,
        ),
        primaryColor: const Color(0xFFFF6B35),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF6B35),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/cart': (context) => const CartScreen(),
        '/payment':
            (context) => const PaymentScreen(totalAmount: 0, cartItems: []),
        '/tracking':
            (context) => const DeliveryTrackingScreen(
              totalAmount: 0,
              orderNumber: '',
              cartItems: [],
              paymentMethod: 'Tarjeta de Crédito',
            ),
        '/completed':
            (context) => const OrderCompletedScreen(
              orderNumber: '',
              totalAmount: 0,
              cartItems: [],
              paymentMethod: 'Tarjeta de Crédito',
            ),
        '/history': (context) => const OrderHistoryScreen(),
        '/rating':
            (context) => const RatingScreen(orderNumber: '', totalAmount: 0),
      },
    );
  }
}
