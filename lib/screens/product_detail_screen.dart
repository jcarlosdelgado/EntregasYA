import 'package:flutter/material.dart';
import 'package:ihc_app/widgets/cart_sidebar.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/cart_manager.dart';
import '../widgets/custom_header.dart';
import '../widgets/product_card.dart';
import '../widgets/circle_back_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product initialProduct;
  final int categoryId;

  const ProductDetailScreen({
    super.key,
    required this.initialProduct,
    required this.categoryId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _currentProduct;
  List<Product> _variants = [];
  bool _isLoading = true;
  final CartManager _cartManager = CartManager();

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.initialProduct;
    _cartManager.addListener(_onCartChanged);
    _loadVariants();
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

  Future<void> _loadVariants() async {
    try {
      final agrupacionId = _currentProduct.agrupacion?.id ?? _currentProduct.id;
      final variants = await ProductService.getProductsByAgrupacion(
        agrupacionId,
        widget.categoryId,
      );

      setState(() {
        _variants = variants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading variants: $e');
    }
  }

  void _selectVariant(Product product) {
    setState(() {
      _currentProduct = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasVariants = _variants.length > 1;

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const CartSidebar(),
      body: Column(
        children: [
          // Header igual al home
          CustomHeader(
            cartItemCount: _cartManager.itemCount, // Usar contador dinámico
            onSearchChanged: () {
              debugPrint('Búsqueda');
            },
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Botón de regreso personalizado
                        CircleBackButton(),
                        const SizedBox(height: 16),

                        // Imagen del producto principal
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey.shade50,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              _currentProduct.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey.shade100,
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported_rounded,
                                    color: Colors.grey.shade400,
                                    size: 64,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Información del producto
                        Text(
                          _currentProduct.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Rating
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < _currentProduct.rating.floor()
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: Colors.amber.shade600,
                                size: 20,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              '(${_currentProduct.rating}) • ${_currentProduct.reviews} reseñas',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Precio
                        Row(
                          children: [
                            Text(
                              _currentProduct.formattedPrice,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFF6B35),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (_currentProduct.hasDiscount)
                              Text(
                                _currentProduct.formattedOldPrice,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          _currentProduct.unit,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Descripción
                        Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentProduct.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Variantes (si existen)
                        if (hasVariants) ...[
                          Text(
                            'Variantes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _variants.length,
                              itemBuilder: (context, index) {
                                final variant = _variants[index];
                                final isSelected = variant.id == _currentProduct.id;
                                
                                return GestureDetector(
                                  onTap: () => _selectVariant(variant),
                                  child: Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected 
                                            ? const Color(0xFFFF6B35)
                                            : Colors.grey.shade300,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                            child: Image.network(
                                              variant.imageUrl,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Container(
                                                color: Colors.grey.shade100,
                                                child: Icon(
                                                  Icons.image_not_supported_rounded,
                                                  color: Colors.grey.shade400,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            variant.formattedPrice,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected 
                                                  ? const Color(0xFFFF6B35)
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],

                        // Botón agregar al carrito
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _cartManager.addItem(
                                CartItem(
                                  id: _currentProduct.id.toString(),
                                  name: _currentProduct.name,
                                  price: _currentProduct.price,
                                  imageUrl: _currentProduct.imageUrl,
                                  unit: _currentProduct.unit,
                                  quantity: 1,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${_currentProduct.name} agregado al carrito'),
                                  backgroundColor: const Color(0xFFFF6B35),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Agregar al Carrito',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
