import 'package:flutter/material.dart';

// Modelo de datos para un ítem en el Carrito
class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String unit; // e.g., 'Kg', 'unidad'
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.unit,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    String? unit,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
    );
  }
}

// Gestor de estado del carrito
class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];
  final double _deliveryFee = 5.0;

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => _deliveryFee;

  double get total => subtotal + deliveryFee;

  bool get isEmpty => _items.isEmpty;

  // Agregar producto al carrito
  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.id == item.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }

    notifyListeners();
  }

  // Actualizar cantidad de un ítem
  void updateQuantity(String itemId, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == itemId);

    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  // Remover ítem del carrito
  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  // Limpiar carrito
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Agregar productos de prueba
  void addTestProducts() {
    clear();

    final testProducts = [
      CartItem(
        id: 'test_1',
        name: 'Manzanas Rojas',
        imageUrl: 'https://placehold.co/100x100/F44336/ffffff?text=Manzanas',
        price: 10.0,
        unit: 'Kg',
        quantity: 2,
      ),
      CartItem(
        id: 'test_2',
        name: 'Leche Entera Larga Vida',
        imageUrl: 'https://placehold.co/100x100/90CAF9/ffffff?text=Leche',
        price: 8.5,
        unit: 'L',
        quantity: 1,
      ),
      CartItem(
        id: 'test_3',
        name: 'Pan Integral',
        imageUrl: 'https://placehold.co/100x100/C59F74/ffffff?text=Pan',
        price: 15.0,
        unit: 'unidad',
        quantity: 3,
      ),
      CartItem(
        id: 'test_4',
        name: 'Pollo Fresco',
        imageUrl: 'https://placehold.co/100x100/FF9800/ffffff?text=Pollo',
        price: 25.0,
        unit: 'Kg',
        quantity: 1,
      ),
    ];

    for (final product in testProducts) {
      _items.add(product);
    }

    notifyListeners();
  }

  // Obtener cantidad de un producto específico
  int getQuantity(String itemId) {
    final item = _items.firstWhere(
      (item) => item.id == itemId,
      orElse:
          () => CartItem(id: '', name: '', imageUrl: '', price: 0, unit: ''),
    );
    return item.id.isNotEmpty ? item.quantity : 0;
  }

  // Verificar si un producto está en el carrito
  bool hasItem(String itemId) {
    return _items.any((item) => item.id == itemId);
  }
}
