import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ihc_app/screens/main_screen.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla para responsividad
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return AnimatedSplashScreen(
      splash: SizedBox(
        width: screenSize.width * 0.8, // 80% del ancho de pantalla
        height: screenSize.height * 0.6, // 60% del alto de pantalla
        child: Center(
          child: Lottie.asset(
            "assets/Lottie/Te_lo_llevo.json",
            // Ajustar tamaño según el dispositivo
            width: isTablet ? 300 : 250,
            height: isTablet ? 300 : 250,
            fit: BoxFit.contain,
            // Optimización de rendimiento
            repeat: true,
            reverse: false,
            animate: true,
            // Manejo de errores
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.shopping_cart,
                size: 100,
                color: Colors.deepOrange,
              );
            },
          ),
        ),
      ),
      nextScreen: const MainScreen(),
      // Tamaño responsivo del splash
      splashIconSize: isTablet ? 400 : 300,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Uso de hex más eficiente
      duration: 3000, // 3 segundos para mejor experiencia
      splashTransition: SplashTransition.fadeTransition, // Transición suave
      pageTransitionType: PageTransitionType.fade,
      animationDuration: const Duration(milliseconds: 2000),
    );
  }
}