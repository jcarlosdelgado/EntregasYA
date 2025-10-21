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

  // Lista de íconos para el NavBar (4 elementos)
  final List<IconData> _icons = const [
    Icons.home_rounded, // 0. HOME (Principal)
    Icons.shopping_cart_rounded, // 1. Carrito
    Icons.history_rounded, // 2. Historial de Pedidos
    Icons.person_rounded, // 3. Perfil de Usuario
  ];

  // Lista de etiquetas para cada ícono
  final List<String> _labels = const [
    'Inicio', // 0. HOME
    'Carrito', // 1. Carrito
    'Historial', // 2. Historial
    'Perfil', // 3. Perfil
  ];

  @override
  Widget build(BuildContext context) {
    // Use orange color scheme
    final Color primaryColor = const Color(0xFFFF6B35); // Naranja principal
    final Color unselectedColor = Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        height: 80, // Un poco más alto para acomodar las etiquetas
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

            return Expanded(
              child: GestureDetector(
                onTap: () => onItemTapped(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Indicador Dinámico (Círculo Rojo)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOut,
                            width:
                                isSelected
                                    ? 42
                                    : 0, // Tamaño uniforme para todos
                            height: isSelected ? 42 : 0,
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
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Icon(
                              _icons[index],
                              key: ValueKey<bool>(isSelected),
                              color:
                                  isSelected ? Colors.white : unselectedColor,
                              size: 24, // Tamaño uniforme para todos los iconos
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Etiqueta del ícono
                      Text(
                        _labels[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? primaryColor : unselectedColor,
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
