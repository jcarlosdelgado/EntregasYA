import 'package:flutter/material.dart';
import 'package:ihc_app/widgets/cart_sidebar.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final int cartItemCount;
  final VoidCallback? onSearchChanged;
  final String searchHint;
  final bool showSearchBar;
  final bool showCartButton;

  const CustomHeader({
    super.key,
    this.title = 'Te lo llevo',
    this.cartItemCount = 0,
    this.onSearchChanged,
    this.searchHint = 'Buscar productos...',
    this.showSearchBar = true,
    this.showCartButton = true, 
  });

  void _openCartSidebar(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final bool noCartNoSearch = !showCartButton && !showSearchBar;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, -1),
          end: Alignment(0, 1),
          colors: [
            Color(0xFFFF825A),
            Color.fromARGB(255, 250, 108, 56),
          ],
          stops: [0.0, 1.0],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, bottom: 10.0, top: 8.0),
          child: Column(
            children: [
              // Header superior con título y carrito
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (showCartButton) // NUEVO: solo muestra si es true
                    GestureDetector(
                      onTap: () => _openCartSidebar(context),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.shopping_cart_rounded,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                          if (cartItemCount > 0)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFB300), // Naranja
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                child: Text(
                                  cartItemCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              if (showSearchBar) ...[
                const SizedBox(height: 5),
                // Barra de búsqueda
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) => onSearchChanged?.call(),
                    decoration: InputDecoration(
                      hintText: searchHint,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                          size: 22,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.mic_outlined,
                          color: const Color(0xFFFB6839),
                          size: 22,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
              ],
              if (noCartNoSearch)
                const SizedBox(height: 5), // Altura extra si no hay search ni carrito
            ],
          ),
        ),
      ),
    );
  }
}
