import 'package:flutter/material.dart';
import 'package:ihc_app/models/sub_categoria.dart';
import 'package:ihc_app/widgets/cart_sidebar.dart';
import '../models/product.dart';
import '../widgets/custom_header.dart';
import '../widgets/product_card.dart';
import '../services/product_service.dart';
import 'product_detail_screen.dart';
import '../widgets/select.dart';
import '../services/cart_manager.dart';
import '../models/category.dart';
import '../widgets/circle_back_button.dart';

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

  // Map para agrupaciones y control de índice actual por agrupación
  Map<int, List<Product>> _agrupaciones = {};
  Map<int, int> _agrupacionIndices = {};

  List<SubCategoria> _subcategorias = [];
  SubCategoria? _selectedSubcategoria;
  final CartManager _cartManager = CartManager();
  List<Category> _categories = [];
  Set<int> _expandedCategoryIds = <int>{};

  @override
  void initState() {
    super.initState();
    _cartManager.addListener(_onCartChanged);
    _loadProducts();
    _loadSubcategorias();
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

  Future<void> _loadProducts() async {
    try {
      List<Product> products;
      if (widget.categoryId == -1) {
        // Mostrar todos los productos destacados
        products = await ProductService.loadProducts();
      } else if (widget.categoryId == -2) {
        // Mostrar todas las promociones
        products = await ProductService.loadPromociones();
      } else {
        products = await ProductService.getProductsByCategory(
          widget.categoryId,
        );
      }

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
      if (widget.categoryId == -1 || widget.categoryId == -2) {
        // Para productos destacados y promociones, cargar todas las categorías
        final categories = await ProductService.loadCategories();
        setState(() {
          _categories = categories;
        });
      } else {
        // Para categorías específicas, cargar solo las subcategorías de esa categoría
        final subcats = await ProductService.getSubcategoriasByCategoria(
          widget.categoryId,
        );
        setState(() {
          _subcategorias = subcats;
        });
      }
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

  void _applyFilters() {
    // Filtrar productos por subcategoría si está seleccionada
    final filteredProducts =
        _selectedSubcategoria == null
            ? _products
            : _products
                .where((p) => p.subcategoria?.id == _selectedSubcategoria!.id)
                .toList();

    // Agrupar productos por agrupacion.id
    final Map<int, List<Product>> agrupaciones = {};
    final Map<int, int> agrupacionIndices = {};
    for (var product in filteredProducts) {
      final agrupacionId = product.agrupacion?.id ?? product.id;
      agrupaciones.putIfAbsent(agrupacionId, () => []);
      agrupaciones[agrupacionId]!.add(product);
      agrupacionIndices.putIfAbsent(agrupacionId, () => 0);
    }

    setState(() {
      _agrupaciones = agrupaciones;
      _agrupacionIndices = agrupacionIndices;
    });
  }

  // Método para mostrar el selector de subcategorías
  void _showSubcategorySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
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
                        Text(
                          widget.categoryId == -1 || widget.categoryId == -2
                              ? 'Filtrar por categoría'
                              : 'Seleccionar subcategoría',
                          style: const TextStyle(
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
                        // Opción "Todas las categorías/subcategorías"
                        Select(
                          title: widget.categoryId == -1 || widget.categoryId == -2
                              ? 'Todas las categorías'
                              : 'Todas las subcategorías',
                          icon: Icons.grid_view_rounded,
                          isSelected: _selectedSubcategoria == null,
                          onTap: () {
                            setState(() {
                              _selectedSubcategoria = null;
                              _applyFilters();
                            });
                            Navigator.pop(context);
                          },
                        ),
                        
                        // Mostrar categorías expandibles o subcategorías simples
                        if (widget.categoryId == -1 || widget.categoryId == -2)
                          // Categorías expandibles para productos destacados y promociones
                          ..._categories.map((category) => Column(
                            children: [
                              // Título de categoría
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  title: Text(
                                    category.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  trailing: Icon(
                                    _expandedCategoryIds.contains(category.id)
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.grey.shade600,
                                  ),
                                  onTap: () {
                                    setModalState(() {
                                      if (_expandedCategoryIds.contains(category.id)) {
                                        _expandedCategoryIds.remove(category.id);
                                      } else {
                                        _expandedCategoryIds.add(category.id);
                                      }
                                    });
                                  },
                                ),
                              ),
                              // Subcategorías (solo si está expandida)
                              if (_expandedCategoryIds.contains(category.id))
                                ...category.subcategorias.map(
                                  (subcat) => Padding(
                                    padding: const EdgeInsets.only(left: 32),
                                    child: Select(
                                      title: subcat.title,
                                      isSelected: _selectedSubcategoria?.id == subcat.id,
                                      onTap: () {
                                        setState(() {
                                          _selectedSubcategoria = subcat;
                                          _applyFilters();
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ))
                        else
                          // Subcategorías simples para categorías específicas
                          ..._subcategorias.map(
                            (subcat) => Select(
                              title: subcat.title,
                              isSelected: _selectedSubcategoria?.id == subcat.id,
                              onTap: () {
                                setState(() {
                                  _selectedSubcategoria = subcat;
                                  _applyFilters();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const CartSidebar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header principal
          CustomHeader(
            title: 'Te lo llevo',
            cartItemCount: _cartManager.itemCount,
            showSearchBar: true,
            searchHint: 'Buscar productos...',
            onSearchChanged: () {
              debugPrint('Búsqueda cambiada desde categoría');
            },
            showCartButton: true, // NUEVO: muestra el botón del carrito
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFFFFEDC6)),
                child: Image.asset(
                  'assets/noisePainter.png',
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 16,
                top: 10,
                child: CircleBackButton(
                  color : const Color.fromARGB(255, 255, 255, 255),
                  iconColor : const Color.fromARGB(255, 3, 3, 3),
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
                        radius: 32,
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: widget.categoryImageUrl!.startsWith('http')
                              ? Image.network(
                                  widget.categoryImageUrl!,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  widget.categoryImageUrl!,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                        ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
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
                              _selectedSubcategoria?.title ??
                                  'Todas las subcategorías',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color:
                                    _selectedSubcategoria != null
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
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _agrupaciones.isEmpty
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
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 240,
                            childAspectRatio: 0.45,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: _agrupaciones.length,
                      itemBuilder: (context, index) {
                        final agrupacionId = _agrupaciones.keys.elementAt(
                          index,
                        );
                        final productosAgrupados = _agrupaciones[agrupacionId]!;
                        final currentIndex = _agrupacionIndices[agrupacionId]!;
                        final product = productosAgrupados[currentIndex];
                        final hasMultipleProducts =
                            productosAgrupados.length > 1;

                        return GestureDetector(
                          onTap: () => _nextProduct(agrupacionId),
                          onHorizontalDragEnd:
                              (_) => _nextProduct(agrupacionId),
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
                                      builder:
                                          (context) => ProductDetailScreen(
                                            initialProduct: product,
                                            categoryId: widget.categoryId,
                                          ),
                                    ),
                                  );
                                },
                                onAddToCart: () => _addToCart(product),
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
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        width: dotIndex == currentIndex ? 8 : 6,
                                        height:
                                            dotIndex == currentIndex ? 8 : 6,
                                        decoration: BoxDecoration(
                                          color:
                                              dotIndex == currentIndex
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
