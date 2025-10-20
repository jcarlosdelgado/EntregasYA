import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../widgets/category_square_card.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_header.dart';
import 'category_products_screen.dart';
import 'product_detail_screen.dart';
import '../services/product_service.dart';

// --- DATOS DE EJEMPLO ---


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> _categories = [];
  List<Product> _products = [];
  List<Product> _promociones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Cargar datos usando ProductService
      final categories = await ProductService.loadCategories();
      final products = await ProductService.loadProducts();
      final promociones = await ProductService.loadPromociones();

      setState(() {
        _categories = categories;
        _products = products;
        _promociones = promociones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.red.shade700;

    // Título de Sección
    Widget _buildSectionTitle(String title, {String? subtitle}) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.grey.shade800,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white, 
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(
                cartItemCount: 2,
                onCartTapped: () {
                  // Navegar al carrito
                  debugPrint('Ir al carrito');
                },
                onSearchChanged: () {
                  // Manejar búsqueda
                  debugPrint('Búsqueda cambiada');
                },
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // SECCIÓN DE CATEGORÍAS
                      _buildSectionTitle('Categorías'),
                      SizedBox(
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: _categories.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 0),
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryProductsScreen(
                                        categoryId: category.id,
                                        categoryTitle: category.title,
                                        categoryImageUrl: category.imageUrl,
                                      ),
                                    ),
                                  );
                                },
                                child: CategorySquareCard(
                                  title: category.title,
                                  imageUrl: category.imageUrl,
                                  primaryColor: primaryColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // SECCIÓN DE PROMOCIONES
                      _buildSectionTitle('Promociones'),
                      SizedBox(
                        height: 380, 
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: _promociones.length,
                          itemBuilder: (context, index) {
                            final product = _promociones[index];
                            return ProductCard(
                              product: product,
                              primaryColor: primaryColor,
                              width: 200,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      initialProduct: product,
                                      categoryId: product.category.id,
                                    ),
                                  ),
                                );
                              },
                              onAddToCart: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product.name} agregado al carrito'),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // SECCIÓN DE PRODUCTOS DESTACADOS
                      _buildSectionTitle(
                        'Productos Destacados', 
                        subtitle: 'Los mejores productos seleccionados para ti',
                      ),
                      SizedBox(
                        height: 380, 
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return ProductCard(
                              product: product,
                              primaryColor: primaryColor,
                              width: 200,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      initialProduct: product,
                                      categoryId: product.category.id,
                                    ),
                                  ),
                                );
                              },
                              onAddToCart: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product.name} agregado al carrito'),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
