
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../widgets/custom_header.dart';
import '../widgets/product_card.dart';


class CategoryProductsScreen extends StatelessWidget {
  final int categoryId;
  final String categoryTitle;
  final String? categoryImageUrl;
  final List<Product> products;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    this.categoryImageUrl,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((p) => p.category.id == categoryId).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header principal
          CustomHeader(
            title: 'Te lo llevo',
            cartItemCount: 2,
            showSearchBar: true,
            searchHint: 'Buscar productos...',
            onCartTapped: () {
              // Navegar al carrito
              debugPrint('Ir al carrito desde categoría');
            },
            onSearchChanged: () {
              // Manejar búsqueda
              debugPrint('Búsqueda cambiada desde categoría');
            },
          ),

          const SizedBox(height: 8), // Separación entre header y la imagen de abajo

          // Header con imagen noise y sección de categoría sobrepuesta
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEDC6), // FEDEC6
                ),
                child: Image.asset(
                  'assets/noisePainter.png',
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black87),
                  ),
                ),
              ),
              // Sección de categoría sobrepuesta en la parte inferior
              Positioned(
                left: 20,
                right: 20,
                bottom: 15,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (categoryImageUrl != null)
                      CircleAvatar(
                        backgroundImage: AssetImage(categoryImageUrl!),
                        radius: 32,
                      ),
                    if (categoryImageUrl != null) const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            categoryTitle,
                            style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${filteredProducts.length} Productos Disponibles',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Filtros y Tabs (puedes expandir esto luego)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.filter_list_rounded, size: 20, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Todas las subcategorías', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Puedes agregar más filtros aquí
              ],
            ),
          ),

          // Lista de productos en grilla
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      'No hay productos en esta categoría',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      childAspectRatio: 0.40, 
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10, 
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        primaryColor: Colors.deepOrange,
                        onTap: () {
                          // Aquí puedes navegar a la pantalla de detalle del producto
                          debugPrint('Producto seleccionado: ${product.name}');
                        },
                        onAddToCart: () {
                          // Lógica para agregar al carrito
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} agregado al carrito'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.deepOrange,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
