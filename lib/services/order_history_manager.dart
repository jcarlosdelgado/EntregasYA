import 'package:flutter/material.dart';
import '../services/cart_manager.dart';

class OrderHistoryItem {
  final String orderNumber;
  final DateTime date;
  final String status;
  final double total;
  final List<CartItem> products; // Productos reales del carrito
  final String deliveryAddress;
  final String paymentMethod;
  final int? rating;

  OrderHistoryItem({
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.total,
    required this.products,
    this.deliveryAddress = 'Av. Principal 123, Ciudad',
    this.paymentMethod = 'Tarjeta de Crédito',
    this.rating,
  });

  // Getters para compatibilidad con la interfaz anterior
  int get itemCount => products.fold(0, (sum, item) => sum + item.quantity);
  int get items => itemCount; // Alias para compatibilidad
  String get restaurantName =>
      'SuperMercado Fresh'; // Nombre fijo del supermercado
  String get deliveryTime => '25 min'; // Tiempo estimado fijo
}

class OrderHistoryManager extends ChangeNotifier {
  static final OrderHistoryManager _instance = OrderHistoryManager._internal();
  factory OrderHistoryManager() => _instance;
  OrderHistoryManager._internal();

  final List<OrderHistoryItem> _orders = [];

  List<OrderHistoryItem> get orders => List.unmodifiable(_orders);

  // Obtener pedidos completados
  List<OrderHistoryItem> get completedOrders =>
      _orders.where((order) => order.status == 'Entregado').toList();

  // Obtener pedidos en progreso
  List<OrderHistoryItem> get activeOrders =>
      _orders.where((order) => order.status != 'Entregado').toList();

  // Agregar un nuevo pedido al historial
  void addOrder({
    required List<CartItem> cartItems,
    required double total,
    required String paymentMethod,
    String? deliveryAddress,
  }) {
    // Generar número de orden más corto (3-4 dígitos)
    final orderNumber =
        'ORD-${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';

    final newOrder = OrderHistoryItem(
      orderNumber: orderNumber,
      date: DateTime.now(),
      status: 'En preparación',
      total: total,
      products: List.from(cartItems), // Copia de los productos del carrito
      paymentMethod: paymentMethod,
      deliveryAddress: deliveryAddress ?? 'Av. Principal 123, Ciudad',
    );

    _orders.insert(
      0,
      newOrder,
    ); // Agregar al inicio para mostrar el más reciente
    notifyListeners();
  }

  // Simular progreso del pedido
  void updateOrderStatus(String orderNumber, String newStatus) {
    final index = _orders.indexWhere(
      (order) => order.orderNumber == orderNumber,
    );
    if (index >= 0) {
      final updatedOrder = OrderHistoryItem(
        orderNumber: _orders[index].orderNumber,
        date: _orders[index].date,
        status: newStatus,
        total: _orders[index].total,
        products: _orders[index].products,
        paymentMethod: _orders[index].paymentMethod,
        deliveryAddress: _orders[index].deliveryAddress,
        rating: _orders[index].rating,
      );
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  // Agregar calificación a un pedido
  void addRating(String orderNumber, int rating) {
    final index = _orders.indexWhere(
      (order) => order.orderNumber == orderNumber,
    );
    if (index >= 0) {
      final updatedOrder = OrderHistoryItem(
        orderNumber: _orders[index].orderNumber,
        date: _orders[index].date,
        status: _orders[index].status,
        total: _orders[index].total,
        products: _orders[index].products,
        paymentMethod: _orders[index].paymentMethod,
        deliveryAddress: _orders[index].deliveryAddress,
        rating: rating,
      );
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  // Limpiar historial (para testing)
  void clearHistory() {
    _orders.clear();
    notifyListeners();
  }

  // Agregar algunos pedidos de ejemplo (opcional)
  void addSampleOrders() {
    if (_orders.isNotEmpty) return; // Solo agregar si no hay pedidos

    // Pedido de ejemplo 1 - Productos frescos
    _orders.add(
      OrderHistoryItem(
        orderNumber: 'ORD-1234',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Entregado',
        total: 58.75,
        products: [
          CartItem(
            id: '1',
            name: 'Aguacate Hass Premium',
            price: 12.50,
            imageUrl:
                'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400&h=400&fit=crop',
            unit: 'Kg',
            quantity: 2,
          ),
          CartItem(
            id: '2',
            name: 'Tomate Cherry Orgánico',
            price: 8.90,
            imageUrl:
                'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&h=400&fit=crop',
            unit: 'bandeja',
            quantity: 1,
          ),
          CartItem(
            id: '3',
            name: 'Yogurt Griego Natural',
            price: 6.45,
            imageUrl:
                'https://images.unsplash.com/photo-1571212515416-fca835ea0129?w=400&h=400&fit=crop',
            unit: 'unidad',
            quantity: 4,
          ),
        ],
        paymentMethod: 'Tarjeta de Crédito',
        rating: 5,
      ),
    );

    // Pedido de ejemplo 2 - Productos de panadería y lácteos
    _orders.add(
      OrderHistoryItem(
        orderNumber: 'ORD-5678',
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: 'Entregado',
        total: 42.30,
        products: [
          CartItem(
            id: '4',
            name: 'Pan Artesanal Integral',
            price: 15.80,
            imageUrl:
                'https://images.unsplash.com/photo-1549931319-a545dcf3bc73?w=400&h=400&fit=crop',
            unit: 'unidad',
            quantity: 1,
          ),
          CartItem(
            id: '5',
            name: 'Queso Mozzarella Fresca',
            price: 18.90,
            imageUrl:
                'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400&h=400&fit=crop',
            unit: 'porción',
            quantity: 1,
          ),
          CartItem(
            id: '6',
            name: 'Huevos Orgánicos',
            price: 7.60,
            imageUrl:
                'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400&h=400&fit=crop',
            unit: 'docena',
            quantity: 1,
          ),
        ],
        paymentMethod: 'QR Code',
        rating: 4,
      ),
    );

    // Pedido de ejemplo 3 - Carnes y vegetales
    _orders.add(
      OrderHistoryItem(
        orderNumber: 'ORD-9012',
        date: DateTime.now().subtract(const Duration(days: 6)),
        status: 'Entregado',
        total: 89.45,
        products: [
          CartItem(
            id: '7',
            name: 'Salmón Fresco Atlántico',
            price: 35.90,
            imageUrl:
                'https://images.unsplash.com/photo-1544943910-4c1dc44aab44?w=400&h=400&fit=crop',
            unit: 'Kg',
            quantity: 1,
          ),
          CartItem(
            id: '8',
            name: 'Espárragos Verdes',
            price: 14.50,
            imageUrl:
                'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400&h=400&fit=crop',
            unit: 'manojo',
            quantity: 2,
          ),
          CartItem(
            id: '9',
            name: 'Aceite de Oliva Extra Virgen',
            price: 24.55,
            imageUrl:
                'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&h=400&fit=crop',
            unit: 'botella',
            quantity: 1,
          ),
        ],
        paymentMethod: 'Tarjeta de Débito',
        rating: 5,
      ),
    );

    // Pedido de ejemplo 4 - Frutas tropicales y snacks
    _orders.add(
      OrderHistoryItem(
        orderNumber: 'ORD-3456',
        date: DateTime.now().subtract(const Duration(days: 8)),
        status: 'Entregado',
        total: 67.80,
        products: [
          CartItem(
            id: '10',
            name: 'Piña Golden Premium',
            price: 18.90,
            imageUrl:
                'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=400&h=400&fit=crop',
            unit: 'unidad',
            quantity: 1,
          ),
          CartItem(
            id: '11',
            name: 'Mango Tommy Premium',
            price: 15.60,
            imageUrl:
                'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&h=400&fit=crop',
            unit: 'Kg',
            quantity: 2,
          ),
          CartItem(
            id: '12',
            name: 'Almendras Natural Premium',
            price: 33.30,
            imageUrl:
                'https://images.unsplash.com/photo-1508061253366-f7da158b6d46?w=400&h=400&fit=crop',
            unit: 'bolsa 500g',
            quantity: 1,
          ),
        ],
        paymentMethod: 'Tarjeta de Crédito',
        rating: 4,
      ),
    );

    // Pedido de ejemplo 5 - Productos de limpieza y hogar
    _orders.add(
      OrderHistoryItem(
        orderNumber: 'ORD-7890',
        date: DateTime.now().subtract(const Duration(days: 10)),
        status: 'Entregado',
        total: 54.25,
        products: [
          CartItem(
            id: '13',
            name: 'Detergente Líquido Premium',
            price: 22.90,
            imageUrl:
                'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=400&h=400&fit=crop',
            unit: 'botella 2L',
            quantity: 1,
          ),
          CartItem(
            id: '14',
            name: 'Papel Higiénico Suave',
            price: 18.45,
            imageUrl:
                'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=400&h=400&fit=crop',
            unit: 'paquete x12',
            quantity: 1,
          ),
          CartItem(
            id: '15',
            name: 'Jabón Antibacterial',
            price: 12.90,
            imageUrl:
                'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=400&fit=crop',
            unit: 'unidad',
            quantity: 1,
          ),
        ],
        paymentMethod: 'QR Code',
        rating: 5,
      ),
    );

    // Pedido de ejemplo 6 - Bebidas y refrescos
    _orders.add(
      OrderHistoryItem(
        orderNumber: 'ORD-2468',
        date: DateTime.now().subtract(const Duration(days: 12)),
        status: 'Entregado',
        total: 38.75,
        products: [
          CartItem(
            id: '16',
            name: 'Agua Mineral Natural',
            price: 8.50,
            imageUrl:
                'https://images.unsplash.com/photo-1550547660-d9450f859349?w=400&h=400&fit=crop',
            unit: 'paquete x6',
            quantity: 2,
          ),
          CartItem(
            id: '17',
            name: 'Jugo de Naranja Natural',
            price: 12.90,
            imageUrl:
                'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&h=400&fit=crop',
            unit: 'botella 1L',
            quantity: 1,
          ),
          CartItem(
            id: '18',
            name: 'Café Gourmet Premium',
            price: 8.85,
            imageUrl:
                'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400&h=400&fit=crop',
            unit: 'bolsa 250g',
            quantity: 1,
          ),
        ],
        paymentMethod: 'Efectivo',
        rating: 3,
      ),
    );

    // Pedido de ejemplo 7 - Cereales y desayuno
    _orders.add(
      OrderHistoryItem(
        orderNumber: 'ORD-1357',
        date: DateTime.now().subtract(const Duration(days: 15)),
        status: 'Entregado',
        total: 71.40,
        products: [
          CartItem(
            id: '19',
            name: 'Avena Integral Premium',
            price: 16.80,
            imageUrl:
                'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=400&fit=crop',
            unit: 'caja 500g',
            quantity: 2,
          ),
          CartItem(
            id: '20',
            name: 'Miel de Abeja Natural',
            price: 24.90,
            imageUrl:
                'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400&h=400&fit=crop',
            unit: 'frasco 450g',
            quantity: 1,
          ),
          CartItem(
            id: '21',
            name: 'Granola Artesanal',
            price: 12.90,
            imageUrl:
                'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=400&h=400&fit=crop',
            unit: 'bolsa 400g',
            quantity: 1,
          ),
        ],
        paymentMethod: 'Tarjeta de Débito',
        rating: 5,
      ),
    );

    // Pedido de ejemplo 8 - Pastas y salsas
    _orders.add(
      OrderHistoryItem(
        orderNumber: 'ORD-8024',
        date: DateTime.now().subtract(const Duration(days: 18)),
        status: 'Entregado',
        total: 45.60,
        products: [
          CartItem(
            id: '22',
            name: 'Pasta Penne Italiana',
            price: 12.45,
            imageUrl:
                'https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?w=400&h=400&fit=crop',
            unit: 'paquete 500g',
            quantity: 2,
          ),
          CartItem(
            id: '23',
            name: 'Salsa de Tomate Casera',
            price: 8.90,
            imageUrl:
                'https://images.unsplash.com/photo-1594736797933-d0401ba4abb9?w=400&h=400&fit=crop',
            unit: 'frasco 400g',
            quantity: 1,
          ),
          CartItem(
            id: '24',
            name: 'Queso Parmesano Rallado',
            price: 11.80,
            imageUrl:
                'https://images.unsplash.com/photo-1452022449339-162275773501?w=400&h=400&fit=crop',
            unit: 'bolsa 100g',
            quantity: 1,
          ),
        ],
        paymentMethod: 'Tarjeta de Crédito',
        rating: 4,
      ),
    );

    // Pedido de ejemplo 9 - Productos congelados
    _orders.add(
      OrderHistoryItem(
        orderNumber: 'ORD-6789',
        date: DateTime.now().subtract(const Duration(days: 20)),
        status: 'Entregado',
        total: 93.15,
        products: [
          CartItem(
            id: '25',
            name: 'Pizza Margherita Artesanal',
            price: 28.50,
            imageUrl:
                'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=400&fit=crop',
            unit: 'unidad',
            quantity: 1,
          ),
          CartItem(
            id: '26',
            name: 'Helado de Vainilla Premium',
            price: 19.90,
            imageUrl:
                'https://images.unsplash.com/photo-1567206563064-6f60f40a2b57?w=400&h=400&fit=crop',
            unit: '1L',
            quantity: 2,
          ),
          CartItem(
            id: '27',
            name: 'Verduras Mixtas Congeladas',
            price: 14.85,
            imageUrl:
                'https://images.unsplash.com/photo-1590777797394-2d34c47a0fc8?w=400&h=400&fit=crop',
            unit: 'bolsa 500g',
            quantity: 1,
          ),
        ],
        paymentMethod: 'QR Code',
        rating: 5,
      ),
    );

    // Pedido de ejemplo 10 - Carnes y embutidos
    _orders.add(
      OrderHistoryItem(
        orderNumber: 'ORD-4791',
        date: DateTime.now().subtract(const Duration(days: 25)),
        status: 'Entregado',
        total: 126.30,
        products: [
          CartItem(
            id: '28',
            name: 'Lomo de Cerdo Premium',
            price: 45.60,
            imageUrl:
                'https://images.unsplash.com/photo-1588347818121-d903485fc9e7?w=400&h=400&fit=crop',
            unit: 'Kg',
            quantity: 1,
          ),
          CartItem(
            id: '29',
            name: 'Jamón Serrano Ibérico',
            price: 52.90,
            imageUrl:
                'https://images.unsplash.com/photo-1449731055826-3b607ee35ff3?w=400&h=400&fit=crop',
            unit: '200g',
            quantity: 1,
          ),
          CartItem(
            id: '30',
            name: 'Chorizo Artesanal',
            price: 27.80,
            imageUrl:
                'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=400&fit=crop',
            unit: 'unidad',
            quantity: 1,
          ),
        ],
        paymentMethod: 'Tarjeta de Crédito',
        rating: 5,
      ),
    );

    notifyListeners();
  }
}
