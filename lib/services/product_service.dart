import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/category.dart';
import '../models/product.dart';
import '../models/sub_categoria.dart';

class ProductService {
  static const String categoriasPath = 'assets/datos/Categorias.json';
  static const String productosPath = 'assets/datos/Productos.json';
  static const String subcategoriasPath = 'assets/datos/Subcategorias.json';

  static Future<List<Category>> loadCategories() async {
    try {
      final String responseCat = await rootBundle.loadString(categoriasPath);
      final String responseSub = await rootBundle.loadString(subcategoriasPath);
      final dataCat = json.decode(responseCat);
      final dataSub = json.decode(responseSub);

      final subcategorias = (dataSub['subcategorias'] as List)
          .map((item) => SubCategoria.fromJson(item))
          .toList();

      return (dataCat['categorias'] as List)
          .map((item) {
            final catId = item['id'];
            final subs = subcategorias.where((s) => s.categoryId == catId).toList();
            return Category.fromJson(item, subcategorias: subs);
          })
          .toList();
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }

  static Future<List<Product>> loadProducts({int? limit}) async {
    try {
      final String response = await rootBundle.loadString(productosPath);
      final data = json.decode(response);
      final products = (data['productos'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
      if (limit != null && limit > 0) {
        return products.take(limit).toList();
      }
      return products;
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }

  static Future<List<Product>> loadPromociones({int? limit}) async {
    try {
      final String response = await rootBundle.loadString(productosPath);
      final data = json.decode(response);
      final promociones = (data['promociones'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
      if (limit != null && limit > 0) {
        return promociones.take(limit).toList();
      }
      return promociones;
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
  static Future<List<Product>> getProductsByAgrupacion(int agrupacionId, int? categoryId) async {
    List<Product> products;
    if (categoryId != null) {
      products = await getProductsByCategory(categoryId);
    } else {
      products = await loadProducts();
    }
    // Filtrar por agrupación
    return products.where((p) => (p.agrupacion?.id ?? p.id) == agrupacionId).toList();
  }

  /// Obtiene las subcategorías de una categoría dada
  static Future<List<SubCategoria>> getSubcategoriasByCategoria(int categoryId) async {
    try {
      final String response = await rootBundle.loadString(subcategoriasPath);
      final data = json.decode(response);
      return (data['subcategorias'] as List)
          .where((item) => item['categoryId'] == categoryId)
          .map((item) => SubCategoria.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Error loading subcategorias: $e');
    }
  }
 
}
