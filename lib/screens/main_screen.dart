import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importante para SystemChrome y SystemUiOverlayStyle
import 'package:ihc_app/screens/home_screen.dart';
import 'package:ihc_app/screens/cart_screen.dart';
import 'package:ihc_app/screens/order_history_screen.dart';
import 'package:ihc_app/screens/profile_screen.dart';
import 'package:ihc_app/widgets/custom_bottom_navbar.dart';

// Pantalla principal que maneja el cambio de pestañas con estado
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Índice 0 corresponde al Home (pantalla principal)
  int _selectedIndex = 0;

  // Lista de pantallas de la aplicación (4 elementos)
  final List<Widget> _screenOptions = <Widget>[
    const HomeScreen(), // Índice 0: HOME (Principal)
    const CartScreen(), // Índice 1: Carrito
    const OrderHistoryScreen(), // Índice 2: Historial de Pedidos
    const ProfileScreen(), // Índice 3: Perfil de Usuario
  ];

  // Función para actualizar el índice al tocar un ítem del NavBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Configurar diferentes estilos de barra de estado según la pantalla
    SystemUiOverlayStyle statusBarStyle;

    if (_selectedIndex == 0) {
      // HomeScreen con header colorido
      statusBarStyle = SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light, // Íconos blancos para header naranja
        statusBarBrightness: Brightness.dark,
      );
    } else {
      statusBarStyle = SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.dark, // Íconos oscuros para otras pantallas
        statusBarBrightness: Brightness.light,
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarStyle,
      child: Scaffold(
        // Muestra la pantalla seleccionada actualmente
        body: _screenOptions.elementAt(_selectedIndex),

        // Asignamos nuestro widget personalizado de la barra de navegación
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        // Fondo muy claro para que el NavBar flotante destaque
        backgroundColor: Colors.grey.shade50,
      ),
    );
  }
}
