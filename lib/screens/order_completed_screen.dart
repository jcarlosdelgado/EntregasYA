import 'package:flutter/material.dart';
import 'package:ihc_app/screens/order_history_screen.dart';
import 'package:ihc_app/screens/rating_screen.dart';
import 'package:ihc_app/services/cart_manager.dart';
import 'package:ihc_app/services/order_history_manager.dart';
import 'package:ihc_app/services/notification_service.dart';

class OrderCompletedScreen extends StatefulWidget {
  final String orderNumber;
  final double totalAmount;
  final List<CartItem> cartItems; // Agregar los productos comprados
  final String paymentMethod;

  const OrderCompletedScreen({
    super.key,
    required this.orderNumber,
    required this.totalAmount,
    required this.cartItems,
    required this.paymentMethod,
  });

  @override
  State<OrderCompletedScreen> createState() => _OrderCompletedScreenState();
}

class _OrderCompletedScreenState extends State<OrderCompletedScreen>
    with TickerProviderStateMixin {
  final Color primaryColor = const Color(0xFFFF6B35); // Naranja principal
  final CartManager _cartManager = CartManager();
  final OrderHistoryManager _orderHistoryManager = OrderHistoryManager();
  late AnimationController _checkController;
  late AnimationController _confettiController;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();

    // Agregar el pedido al historial ANTES de limpiar el carrito
    _orderHistoryManager.addOrder(
      cartItems: widget.cartItems,
      total: widget.totalAmount,
      paymentMethod: widget.paymentMethod,
    );

    // Limpiar el carrito al completar el pedido
    _cartManager.clear();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );

    // Iniciar animaciones
    _checkController.forward();
    _confettiController.repeat();

    // Mostrar notificación de pedido completado
    _showOrderCompletedNotification();
  }

  Future<void> _showOrderCompletedNotification() async {
    // Esperar un poco para que la pantalla se cargue completamente
    await Future.delayed(const Duration(milliseconds: 500));

    await NotificationService().showOrderCompletedNotification(
      orderNumber: widget.orderNumber,
      totalAmount: widget.totalAmount,
    );
  }

  @override
  void dispose() {
    _checkController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50, // Fondo naranja claro
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Animación de check completado
              _buildSuccessAnimation(),

              const SizedBox(height: 32),

              // Mensaje principal
              _buildSuccessMessage(),

              const SizedBox(height: 24),

              // Detalles del pedido
              _buildOrderDetails(),

              const SizedBox(height: 32),

              // Información adicional
              _buildAdditionalInfo(),

              const SizedBox(height: 40),

              // Botones de acción
              _buildActionButtons(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return AnimatedBuilder(
      animation: _checkAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _checkAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 60),
          ),
        );
      },
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        const Text(
          '¡Pedido Entregado!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Tu pedido ha sido entregado exitosamente',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(
            'Número de pedido',
            '#${widget.orderNumber}',
            Icons.receipt_long,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            'Total pagado',
            'Bs ${widget.totalAmount.toStringAsFixed(2)}',
            Icons.payments,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            'Fecha de entrega',
            _formatDateTime(DateTime.now()),
            Icons.calendar_today,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            'Estado',
            'Completado',
            Icons.check_circle,
            valueColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Gracias por tu compra!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tu factura se enviará por correo electrónico. Si tienes alguna pregunta, contáctanos.',
                  style: TextStyle(color: Colors.blue.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Botón principal - Volver al inicio
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.home),
            label: const Text('Volver al Inicio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Botón secundario - Ver historial
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.history),
            label: const Text('Ver Historial de Pedidos'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Botón terciario - Calificar experiencia
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => RatingScreen(
                        orderNumber: widget.orderNumber,
                        totalAmount: widget.totalAmount,
                      ),
                ),
              );
            },
            icon: const Icon(Icons.star_outline),
            label: const Text('Calificar Experiencia'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    return '${dateTime.day} de ${months[dateTime.month - 1]}, ${dateTime.year}';
  }
}
