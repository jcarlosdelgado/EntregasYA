import 'package:flutter/material.dart';
import 'package:ihc_app/screens/main_screen.dart'; 
import 'package:ihc_app/screens/animation/splashScreen.dart';
import 'package:ihc_app/screens/cart_screen.dart';
import 'package:ihc_app/screens/delivery_tracking_screen.dart';
import 'package:ihc_app/screens/order_completed_screen.dart';
import 'package:ihc_app/screens/order_history_screen.dart';
import 'package:ihc_app/screens/rating_screen.dart';
import 'package:ihc_app/screens/address_management_screen.dart';
import 'package:ihc_app/services/notification_service.dart';
import 'package:ihc_app/screens/category_products_screen.dart';
import 'package:ihc_app/screens/payment/payment_screen.dart';

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
      // home: const SplashScreen(),
      home: const MainScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/cart': (context) => const CartScreen(),
        '/payment': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return PaymentScreen(
            totalAmount: args != null && args['totalAmount'] != null ? args['totalAmount'] as double : 0,
            cartItems: args != null && args['cartItems'] != null ? List.from(args['cartItems']) : [],
            deliveryAddress: args?['deliveryAddress'],
          );
        },
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
        '/category_products': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CategoryProductsScreen(
            categoryId: args['categoryId'] ?? 0,
            categoryTitle: args['categoryTitle'] ?? '',
            categoryImageUrl: args['categoryImageUrl'],
          );
        },
        '/all_products': (context) => CategoryProductsScreen(
              categoryId: -1,
              categoryTitle: 'Todos los productos',
              categoryImageUrl: null,
            ),
        '/all_promos': (context) => CategoryProductsScreen(
              categoryId: -2,
              categoryTitle: 'Promociones',
              categoryImageUrl: 'https://www.prexus.co/uploads/1/3/0/6/13063909/promociones_orig.jpg',
            ),
        '/address_management': (context) => const AddressManagementScreen(),
      },
    );
  }
}
