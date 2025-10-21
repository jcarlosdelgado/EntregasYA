import 'package:flutter/material.dart';
import 'package:ihc_app/screens/delivery_tracking_screen.dart';
import 'package:ihc_app/screens/rating_screen.dart';
import 'package:ihc_app/services/order_history_manager.dart';
import 'package:ihc_app/services/cart_manager.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with TickerProviderStateMixin {
  final Color primaryColor = const Color(0xFFFF6B35); // Naranja principal
  final OrderHistoryManager _orderHistoryManager = OrderHistoryManager();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _orderHistoryManager.addListener(_onOrdersChanged);

    // Agregar pedidos de ejemplo solo si no hay pedidos
    _orderHistoryManager.addSampleOrders();
  }

  void _onOrdersChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _orderHistoryManager.removeListener(_onOrdersChanged);
    _tabController.dispose();
    super.dispose();
  }

  List<OrderHistoryItem> get activeOrders => _orderHistoryManager.activeOrders;

  List<OrderHistoryItem> get completedOrders =>
      _orderHistoryManager.completedOrders;

  List<OrderHistoryItem> get allOrders => _orderHistoryManager.orders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Historial de Pedidos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF6B35), // Fondo naranja
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Todos'),
            Tab(text: 'Activos'),
            Tab(text: 'Completados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(allOrders),
          _buildOrderList(activeOrders),
          _buildOrderList(completedOrders),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderHistoryItem> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay pedidos',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderHistoryItem order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _onOrderTap(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con número de pedido y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Información del pedido
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.restaurantName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${order.items} productos • ${_formatDate(order.date)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Bs ${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Rating o botones de acción
              if (order.status == 'Entregado') ...[
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (order.rating != null && order.rating! > 0) ...[
                      Row(
                        children: [
                          Text(
                            'Tu calificación: ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          ...List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              size: 16,
                              color:
                                  index < order.rating!
                                      ? Colors.amber
                                      : Colors.grey.shade300,
                            );
                          }),
                        ],
                      ),
                    ] else ...[
                      Text(
                        'Sin calificar',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => _reorderItems(order),
                          child: Text('Pedir otra vez'),
                        ),
                        if (order.rating == 0)
                          TextButton(
                            onPressed: () => _rateOrder(order),
                            child: Text('Calificar'),
                          ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                const Divider(),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      'Tiempo estimado: ${order.deliveryTime}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _trackOrder(order),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Seguir'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Entregado':
        return Colors.green;
      case 'En camino':
        return Colors.orange;
      case 'Preparando':
        return Colors.blue;
      case 'Cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _onOrderTap(OrderHistoryItem order) {
    _showOrderDetails(order);
  }

  void _showOrderDetails(OrderHistoryItem order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOrderDetailsSheet(order),
    );
  }

  Widget _buildOrderDetailsSheet(OrderHistoryItem order) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle para arrastrar
              Container(
                margin: const EdgeInsets.only(top: 8),
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
                    Expanded(
                      child: Text(
                        'Pedido #${order.orderNumber}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Contenido scrolleable
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Detalles del pedido
                      _buildDetailSection('Estado del Pedido', [
                        _buildDetailRow('Estado', order.status),
                        _buildDetailRow('Fecha', _formatDate(order.date)),
                        _buildDetailRow(
                          'Total',
                          'Bs ${order.total.toStringAsFixed(2)}',
                        ),
                        _buildDetailRow('Productos', '${order.items} items'),
                      ]),

                      const SizedBox(height: 20),

                      // Productos reales del pedido
                      _buildDetailSection(
                        'Productos',
                        order.products
                            .map(
                              (product) => _buildProductRowWithImage(product),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 20),

                      if (order.status == 'Entregado') ...[
                        _buildActionButtons(order),
                      ] else ...[
                        _buildActiveOrderActions(order),
                      ],

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRowWithImage(CartItem product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.shopping_bag,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${product.quantity} ${product.unit}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Bs ${(product.price * product.quantity).toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 14,
                ),
              ),
              if (product.quantity > 1)
                Text(
                  'Bs ${product.price.toStringAsFixed(2)} c/u',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(OrderHistoryItem order) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _reorderItems(order),
            icon: const Icon(Icons.repeat),
            label: const Text('Pedir otra vez'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (order.rating == 0)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _rateOrder(order),
              icon: const Icon(Icons.star_outline),
              label: const Text('Calificar Experiencia'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActiveOrderActions(OrderHistoryItem order) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _trackOrder(order),
        icon: const Icon(Icons.location_on),
        label: const Text('Seguir Pedido'),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _trackOrder(OrderHistoryItem order) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DeliveryTrackingScreen(
              totalAmount: order.total,
              orderNumber: order.orderNumber,
              cartItems: order.products,
              paymentMethod: order.paymentMethod,
            ),
      ),
    );
  }

  void _reorderItems(OrderHistoryItem order) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Productos del pedido #${order.orderNumber} agregados al carrito',
        ),
        action: SnackBarAction(
          label: 'Ver Carrito',
          onPressed: () {
            // Navegar al carrito
          },
        ),
      ),
    );
  }

  void _rateOrder(OrderHistoryItem order) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => RatingScreen(
              orderNumber: order.orderNumber,
              totalAmount: order.total,
            ),
      ),
    );
  }
}
