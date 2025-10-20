import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/custom_header.dart';
import '../widgets/product_card.dart';
import '../services/cart_manager.dart';

class CategoryProductsScreen extends StatefulWidget {
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
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final CartManager _cartManager = CartManager();

  @override
  void initState() {
    super.initState();
    _cartManager.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartManager.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _addToCart(Product product) {
    _cartManager.addItem(
      CartItem(
        id: product.id.toString(),
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
        unit: 'unidad',
        quantity: 1,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} agregado al carrito'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFFFF6B35), // Naranja principal
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts =
        widget.products
            .where((p) => p.category.id == widget.categoryId)
            .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header principal
          CustomHeader(
            title: 'Te lo llevo',
            cartItemCount: _cartManager.itemCount,
            showSearchBar: true,
            searchHint: 'Buscar productos...',
            onCartTapped: () {
              // Navegar al carrito
              Navigator.pushNamed(context, '/cart');
            },
            onSearchChanged: () {
              // Manejar búsqueda
              debugPrint('Búsqueda cambiada desde categoría');
            },
          ),

          const SizedBox(
            height: 8,
          ), // Separación entre header y la imagen de abajo
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
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Colors.black87,
                    ),
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
                    if (widget.categoryImageUrl != null)
                      CircleAvatar(
                        backgroundImage: AssetImage(widget.categoryImageUrl!),
                        radius: 32,
                      ),
                    if (widget.categoryImageUrl != null)
                      const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.categoryTitle,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.filter_list_rounded,
                          size: 20,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Todas las subcategorías',
                          style: TextStyle(fontSize: 15),
                        ),
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
            child:
                filteredProducts.isEmpty
                    ? const Center(
                      child: Text(
                        'No hay productos en esta categoría',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ), // padding simétrico
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 240,
                            childAspectRatio: 0.45,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          primaryColor: Colors.deepOrange,
                          // Nuevo: sin margen lateral derecho en grilla
                          margin: const EdgeInsets.only(
                            bottom: 8,
                          ), // solo margen inferior
                          onTap: () {
                            // Aquí puedes navegar a la pantalla de detalle del producto
                            debugPrint(
                              'Producto seleccionado: ${product.name}',
                            );
                          },
                          onAddToCart: () => _addToCart(product),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
