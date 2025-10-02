import 'package:flutter/material.dart';

// Definición de un modelo de datos básico para un ítem en el Carrito
// Usamos un StatefulWidget para manejar la cantidad de cada ítem
class CartItem {
  final String name;
  final String imageUrl;
  final double price;
  final String unit; // e.g., 'Kg', 'unidad'
  int quantity;

  CartItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.unit,
    this.quantity = 1,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Color principal de la aplicación
  final Color primaryColor = Colors.red.shade700;
  
  // Lista de ítems en el carrito (Datos de ejemplo)
  final List<CartItem> cartItems = [
    CartItem(
      name: 'Manzanas Rojas',
      imageUrl: 'https://placehold.co/100x100/F44336/ffffff?text=Manzanas',
      price: 10.0,
      unit: 'Kg',
      quantity: 2,
    ),
    CartItem(
      name: 'Leche Entera Larga Vida',
      imageUrl: 'https://placehold.co/100x100/90CAF9/ffffff?text=Leche',
      price: 8.5,
      unit: 'L',
      quantity: 1,
    ),
    CartItem(
      name: 'Pan Integral',
      imageUrl: 'https://placehold.co/100x100/C59F74/ffffff?text=Pan',
      price: 15.0,
      unit: 'unidad',
      quantity: 3,
    ),
  ];

  // Lógica para calcular el subtotal total del carrito
  double get subtotal {
    return cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Costo de envío (fijo para el ejemplo)
  final double deliveryFee = 5.0;

  // Lógica para calcular el total a pagar
  double get total => subtotal + deliveryFee;

  // Función para incrementar o decrementar la cantidad de un ítem
  void _updateQuantity(int index, int change) {
    setState(() {
      cartItems[index].quantity += change;
      if (cartItems[index].quantity <= 0) {
        cartItems.removeAt(index); // Eliminar si la cantidad llega a 0 o menos
      }
    });
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
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    '¡Tu carrito está vacío!',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Lista de Ítems del Carrito
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 250.0), // Padding para el resumen
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return CartItemCard(
                      item: item,
                      primaryColor: primaryColor,
                      onQuantityChanged: (change) => _updateQuantity(index, change),
                    );
                  },
                ),
                
                // Resumen de Compra Flotante (Checkout)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CheckoutSummary(
                    subtotal: subtotal,
                    deliveryFee: deliveryFee,
                    total: total,
                    primaryColor: primaryColor,
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
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey.shade200,
                  child: Center(child: Icon(Icons.shopping_bag_outlined, color: primaryColor)),
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
        child: Icon(
          icon,
          color: primaryColor,
          size: 20,
        ),
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

  const CheckoutSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.primaryColor,
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
                      // Lógica para ir a la pantalla de pago
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('¡Procesando pago!')),
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
