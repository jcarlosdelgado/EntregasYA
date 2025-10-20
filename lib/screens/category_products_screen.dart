import 'package:flutter/material.dart';
import 'package:ihc_app/models/sub_categoria.dart';
import '../models/product.dart';
import '../widgets/custom_header.dart';
import '../widgets/product_card.dart';
import '../services/product_service.dart';
import 'product_detail_screen.dart';
import '../widgets/select.dart';

class CategoryProductsScreen extends StatefulWidget {
  final int categoryId;
  final String categoryTitle;
  final String? categoryImageUrl;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    this.categoryImageUrl,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Product> _products = [];
  bool _isLoading = true;

  // Nuevo: Map para agrupaciones y control de índice actual por agrupación
  Map<int, List<Product>> _agrupaciones = {};
  Map<int, int> _agrupacionIndices = {};

  List<SubCategoria> _subcategorias = [];
  SubCategoria? _selectedSubcategoria;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadSubcategorias();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await ProductService.getProductsByCategory(widget.categoryId);

      // Agrupar productos por agrupacion.id
      final Map<int, List<Product>> agrupaciones = {};
      final Map<int, int> agrupacionIndices = {};
      for (var product in products) {
        final agrupacionId = product.agrupacion?.id ?? product.id;
        agrupaciones.putIfAbsent(agrupacionId, () => []);
        agrupaciones[agrupacionId]!.add(product);
        agrupacionIndices.putIfAbsent(agrupacionId, () => 0);
      }

      setState(() {
        _products = products;
        _agrupaciones = agrupaciones;
        _agrupacionIndices = agrupacionIndices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading category products: $e');
    }
  }

  Future<void> _loadSubcategorias() async {
    try {
      final subcats = await ProductService.getSubcategoriasByCategoria(widget.categoryId);
      setState(() {
        _subcategorias = subcats;
      });
    } catch (e) {
      debugPrint('Error loading subcategorias: $e');
    }
  }

  // Cambia el producto mostrado en la agrupación (siguiente)
  void _nextProduct(int agrupacionId) {
    setState(() {
      final count = _agrupaciones[agrupacionId]!.length;
      _agrupacionIndices[agrupacionId] =
          (_agrupacionIndices[agrupacionId]! + 1) % count;
    });
  }

  // Nuevo método para mostrar el selector de subcategorías
  void _showSubcategorySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      color: Colors.deepOrange,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Seleccionar subcategoría',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Lista de opciones
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    // Opción "Todas las subcategorías"
                    Select(
                      title: 'Todas las subcategorías',
                      icon: Icons.grid_view_rounded,
                      isSelected: _selectedSubcategoria == null,
                      onTap: () {
                        setState(() {
                          _selectedSubcategoria = null;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    // Opciones de subcategorías
                    ..._subcategorias.map((subcat) => Select(
                      title: subcat.title,
                      icon: Icons.label_outline, 
                      isSelected: _selectedSubcategoria?.id == subcat.id,
                      onTap: () {
                        setState(() {
                          _selectedSubcategoria = subcat;
                        });
                        Navigator.pop(context);
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildSubcategoryOption({
  //   required String title,
  //   required IconData icon,
  //   required bool isSelected,
  //   required VoidCallback onTap,
  // }) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: isSelected ? Colors.deepOrange.withOpacity(0.08) : Colors.transparent,
  //       borderRadius: BorderRadius.circular(12),
  //       border: isSelected 
  //         ? Border.all(color: Colors.deepOrange.withOpacity(0.3), width: 1.5)
  //         : null,
  //     ),
  //     child: ListTile(
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //       leading: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: isSelected ? Colors.deepOrange : Colors.grey.shade100,
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: Icon(
  //           icon,
  //           color: isSelected ? Colors.white : Colors.grey.shade600,
  //           size: 20,
  //         ),
  //       ),
  //       title: Text(
  //         title,
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
  //           color: isSelected ? Colors.deepOrange.shade700 : Colors.black87,
  //         ),
  //       ),
  //       trailing: isSelected
  //         ? Icon(
  //             Icons.check_circle,
  //             color: Colors.deepOrange,
  //             size: 22,
  //           )
  //         : Icon(
  //             Icons.arrow_forward_ios,
  //             color: Colors.grey.shade400,
  //             size: 16,
  //           ),
  //       onTap: onTap,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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
              debugPrint('Ir al carrito desde categoría');
            },
            onSearchChanged: () {
              debugPrint('Búsqueda cambiada desde categoría');
            },
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEDC6),
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
                    if (widget.categoryImageUrl != null) const SizedBox(width: 16),
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
                            '${_products.length} Productos Disponibles',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showSubcategorySelector,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              size: 18,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedSubcategoria?.title ?? 'Todas las subcategorías',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: _selectedSubcategoria != null 
                                  ? Colors.deepOrange.shade700 
                                  : Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.expand_more_rounded,
                            color: Colors.grey.shade500,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _agrupaciones.isEmpty
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 240,
                          childAspectRatio: 0.45,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _agrupaciones.length,
                        itemBuilder: (context, index) {
                          final agrupacionId = _agrupaciones.keys.elementAt(index);
                          final productosAgrupados = _agrupaciones[agrupacionId]!;
                          final currentIndex = _agrupacionIndices[agrupacionId]!;
                          final product = productosAgrupados[currentIndex];
                          final hasMultipleProducts = productosAgrupados.length > 1;

                          return GestureDetector(
                            onTap: () => _nextProduct(agrupacionId),
                            onHorizontalDragEnd: (_) => _nextProduct(agrupacionId),
                            child: Stack(
                              children: [
                                ProductCard(
                                  product: product,
                                  primaryColor: Colors.deepOrange,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailScreen(
                                          initialProduct: product,
                                          categoryId: widget.categoryId,
                                        ),
                                      ),
                                    );
                                  },
                                  onAddToCart: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.name} agregado al carrito'),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.deepOrange,
                                      ),
                                    );
                                  },
                                ),
                                // Indicadores visuales para múltiples productos
                                if (hasMultipleProducts) ...[
                                  // Puntos indicadores en la parte inferior
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    right: 16,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                        productosAgrupados.length,
                                        (dotIndex) => Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 2),
                                          width: dotIndex == currentIndex ? 8 : 6,
                                          height: dotIndex == currentIndex ? 8 : 6,
                                          decoration: BoxDecoration(
                                            color: dotIndex == currentIndex
                                                ? Colors.deepOrange
                                                : Colors.grey.shade400,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Icono de swipe en la esquina superior izquierda
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.swipe_left_rounded,
                                            size: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${currentIndex + 1}/${productosAgrupados.length}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
