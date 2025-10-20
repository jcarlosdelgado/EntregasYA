import 'package:flutter/material.dart';
import 'package:ihc_app/services/cart_manager.dart';
import 'package:ihc_app/screens/payment_screen.dart';

// Carrito de compras usando CartManager para el estado
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Color principal de la aplicación
  final Color primaryColor = const Color(0xFFFF6B35); // Naranja principal
  final CartManager _cartManager = CartManager();

  @override
  void initState() {
    super.initState();
    _cartManager.addListener(_onCartChanged);
    // El carrito inicia vacío - los productos se agregan desde otras pantallas
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

  // Función para incrementar o decrementar la cantidad de un ítem
  void _updateQuantity(String itemId, int change) {
    final currentQuantity = _cartManager.getQuantity(itemId);
    _cartManager.updateQuantity(itemId, currentQuantity + change);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tu Carrito',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFFF6B35), // Fondo naranja
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      body:
          _cartManager.items.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¡Tu carrito está vacío!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Botón para ir a agregar productos
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        ); // Ir al home_screen
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Agregar Productos'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Stack(
                children: [
                  // Lista de Ítems del Carrito
                  ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 250.0,
                    ), // Padding para el resumen
                    itemCount: _cartManager.items.length,
                    itemBuilder: (context, index) {
                      final item = _cartManager.items[index];
                      return CartItemCard(
                        item: item,
                        primaryColor: primaryColor,
                        onQuantityChanged:
                            (change) => _updateQuantity(item.id, change),
                      );
                    },
                  ),

                  // Resumen de Compra Flotante (Checkout)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CheckoutSummary(
                      subtotal: _cartManager.subtotal,
                      deliveryFee: _cartManager.deliveryFee,
                      total: _cartManager.total,
                      primaryColor: primaryColor,
                      cartItems: _cartManager.items,
                    ),
                  ),
                ],
              ),
    );
  }
}

// --- WIDGETS REUTILIZABLES ---

// Tarjeta Individual para cada Ítem del Carrito
class CartItemCard extends StatelessWidget {
  final CartItem item;
  final Color primaryColor;
  final Function(int) onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.item,
    required this.primaryColor,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen del Producto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: primaryColor,
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(width: 12),

            // Nombre y Precio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bs ${item.price.toStringAsFixed(2)} / ${item.unit}',
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Botones de Cantidad y Cantidad Actual
            Row(
              children: [
                // Botón Menos (-)
                _buildQuantityButton(
                  icon: Icons.remove,
                  onTap: () => onQuantityChanged(-1),
                  primaryColor: primaryColor,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Botón Más (+)
                _buildQuantityButton(
                  icon: Icons.add,
                  onTap: () => onQuantityChanged(1),
                  primaryColor: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper para los botones de cantidad
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
    );
  }
}

// Resumen de Compra Flotante
class CheckoutSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;
  final Color primaryColor;
  final List<CartItem> cartItems;

  const CheckoutSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.primaryColor,
    required this.cartItems,
  });

  // Función helper para la fila de detalle de precio
  Widget _buildDetailRow(String title, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.white : Colors.grey.shade700,
            ),
          ),
          Text(
            'Bs ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? Colors.white : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sección de Resumen
          _buildDetailRow('Subtotal de Productos', subtotal),
          _buildDetailRow('Costo de Envío', deliveryFee),

          const Divider(height: 20, thickness: 1),

          // Sección de Total y Botón de Pago
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildDetailRow('Total a Pagar', total, isTotal: true),
                const SizedBox(height: 12),

                // Botón de Checkout (rojo)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla de pago con los datos del carrito
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PaymentScreen(
                                totalAmount: total,
                                cartItems: cartItems,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'PAGAR AHORA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
