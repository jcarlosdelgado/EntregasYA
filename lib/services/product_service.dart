import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/category.dart';
import '../models/product.dart';

class ProductService {
  static const String categoriasPath = 'assets/datos/Categorias.json';
  static const String productosPath = 'assets/datos/Productos.json';

  static Future<List<Category>> loadCategories() async {
    try {
      final String response = await rootBundle.loadString(categoriasPath);
      final data = json.decode(response);
      return (data['categorias'] as List)
          .map((item) => Category.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }

  static Future<List<Product>> loadProducts() async {
    try {
      final String response = await rootBundle.loadString(productosPath);
      final data = json.decode(response);
      return (data['productos'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }

  static Future<List<Product>> loadPromociones() async {
    try {
      final String response = await rootBundle.loadString(productosPath);
      final data = json.decode(response);
      return (data['promociones'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Error loading promociones: $e');
    }
  }

  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final String response = await rootBundle.loadString(productosPath);
      final data = json.decode(response);

      final productos = (data['productos'] as List)
          .map((item) => Product.fromJson(item))
          .where((product) => product.category.id == categoryId)
          .toList();

      final promociones = (data['promociones'] as List)
          .map((item) => Product.fromJson(item))
          .where((product) => product.category.id == categoryId)
          .toList();

      return [...productos, ...promociones];
    } catch (e) {
      throw Exception('Error loading products by category: $e');
    }
  }

  /// Obtiene los productos de una agrupación, de una categoría dada
  static Future<List<Product>> getProductsByAgrupacion(int agrupacionId, int categoryId) async {
    List<Product> products;
      products = await getProductsByCategory(categoryId);
    // Filtrar por agrupación
    return products.where((p) => (p.agrupacion?.id ?? p.id) == agrupacionId).toList();
  }
}
