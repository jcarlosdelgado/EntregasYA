import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importante para SystemChrome y SystemUiOverlayStyle
import 'package:ihc_app/screens/home_screen.dart';
import 'package:ihc_app/screens/explore_screen.dart';
import 'package:ihc_app/screens/cart_screen.dart';
import 'package:ihc_app/screens/profile_screen.dart';
import 'package:ihc_app/screens/offers_screen.dart';
import 'package:ihc_app/widgets/custom_bottom_navbar.dart';

// Pantalla principal que maneja el cambio de pestañas con estado
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Índice 2 corresponde al Home, la nueva posición central
  int _selectedIndex = 2; 

  // Lista de todas las pantallas de la aplicación (5 elementos)
  final List<Widget> _screenOptions = <Widget>[
    const ExploreScreen(),    // Índice 0: Explorar
    const OffersScreen(),     // Índice 1: Ofertas
    const HomeScreen(),       // Índice 2: HOME (Centrado)
    const CartScreen(),       // Índice 3: Carrito
    const ProfileScreen(),    // Índice 4: Perfil
  ];

  // Función para actualizar el índice al tocar un ítem del NavBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usamos AnnotatedRegion para controlar el estilo de la barra de estado
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, // Fondo transparente
        statusBarIconBrightness: Brightness.dark, // Íconos (hora, batería) en negro
        statusBarBrightness: Brightness.light, // Controla iOS (el contenido es claro, por eso íconos oscuros)
      ),
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
