import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/category.dart';
import '../models/product.dart';
import '../widgets/category_square_card.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_header.dart';

// --- DATOS DE EJEMPLO ---
const List<Category> _categories = [
  Category(
    title: 'Frutas y Verduras',
    imageUrl: 'assets/images/categorias/FrutasVerduras.png',
  ),
  Category(
    title: 'Carnes y Pescados',
    imageUrl: 'assets/images/categorias/CarnesPescados.png',
  ),
  Category(
    title: 'Lácteos y Huevos',
    imageUrl: 'assets/images/categorias/Lacteos.png',
  ),
  Category(
    title: 'Panadería',
    imageUrl: 'assets/images/categorias/panaderia.png',
  ),
  Category(
    title: 'Despensa',
    imageUrl: 'assets/images/categorias/Despensa.png',
  ),
  Category(
    title: ' Bebidas',
    imageUrl: 'assets/images/categorias/Bebidas.png',
  ),
  Category(
    title: 'Limpieza',
    imageUrl: 'assets/images/categorias/Limpieza.png',
  ),
  Category(
    title: 'Cuidado Personal',
    imageUrl: 'assets/images/categorias/CuidadoPersonal.png',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  List<Product> _promociones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final String response = await rootBundle.loadString('assets/datos/Productos.json');
      final data = json.decode(response);
      
      setState(() {
        _products = (data['productos'] as List)
            .map((item) => Product.fromJson(item))
            .toList();
        _promociones = (data['promociones'] as List)
            .map((item) => Product.fromJson(item))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading products: $e');
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
                              child: CategorySquareCard(
                                title: category.title,
                                imageUrl: category.imageUrl,
                                primaryColor: primaryColor,
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
                            return ProductCard(product: product, primaryColor: primaryColor);
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
                            return ProductCard(product: product, primaryColor: primaryColor);
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
