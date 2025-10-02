import 'package:flutter/material.dart';

// Widget de la Barra de Navegación inferior
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  // Lista de íconos para el NavBar (5 elementos)
  final List<IconData> _icons = const [
    Icons.grid_view_rounded,    // 0. Explorar
    Icons.local_offer_rounded,  // 1. Ofertas
    Icons.home_rounded,         // 2. HOME (Central y Destacado)
    Icons.shopping_cart_sharp,  // 3. Carrito
    Icons.person_rounded,       // 4. Perfil
  ];

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.red.shade700;
    final Color unselectedColor = Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        height: 70, 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final isSelected = index == selectedIndex;
            final isCenterButton = index == 2; // El Home está en la posición 2

            return Expanded(
              child: GestureDetector(
                onTap: () => onItemTapped(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Indicador Dinámico (Círculo Rojo)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 350), 
                        curve: Curves.easeOut, 
                        width: isSelected ? (isCenterButton ? 60 : 48) : 0, // El centro es más grande
                        height: isSelected ? (isCenterButton ? 60 : 48) : 0,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      
                      // Ícono con Transición de Color y Escala
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation, 
                            child: FadeTransition(opacity: animation, child: child),
                          );
                        },
                        child: Icon(
                          _icons[index],
                          key: ValueKey<bool>(isSelected),
                          color: isSelected ? Colors.white : unselectedColor,
                          size: isCenterButton ? 32 : 28, // El ícono central es ligeramente más grande siempre
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
