import 'package:flutter/material.dart';

// --- MODELOS DE DATOS ---

// Modelo de datos para las categorías
class Category {
  final String title;
  final String imageUrl; // Usamos URL para simular la imagen
  const Category({required this.title, required this.imageUrl});
}

// Modelo de datos para los productos
class Product {
  final String name;
  final String description;
  final String priceBs;
  final String oldPriceBs;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String badge; // Ej: 'Nuevo' o '-20%'

  const Product({
    required this.name,
    required this.description,
    required this.priceBs,
    required this.oldPriceBs,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.badge,
  });
}

// --- DATOS DE EJEMPLO ---

const List<Category> _categories = [
  Category(
    title: 'Frutas y Verduras',
    imageUrl: 'https://placehold.co/100x100/A5D6A7/ffffff?text=Frutas', // Green
  ),
  Category(
    title: 'Carnes y Pescados',
    imageUrl: 'https://placehold.co/100x100/EF9A9A/ffffff?text=Carnes', // Red
  ),
  Category(
    title: 'Lácteos y Huevos',
    imageUrl: 'https://placehold.co/100x100/90CAF9/ffffff?text=Lácteos', // Blue
  ),
  // Añadimos más para el scroll horizontal
  Category(
    title: 'Panadería',
    imageUrl: 'https://placehold.co/100x100/C59F74/ffffff?text=Pan', // Brown
  ),
];

const List<Product> _products = [
  Product(
    name: 'Manzanas Rojas',
    description: 'Manzanas rojas frescas y crujientes, perfectas para snacks saludables.',
    priceBs: 'Bs 10',
    oldPriceBs: '22 Bs',
    rating: 4.5,
    reviews: 128,
    imageUrl: 'https://placehold.co/300x200/F44336/ffffff?text=Producto+Limpieza', // Red image
    badge: 'Nuevo 20%',
  ),
  Product(
    name: 'Detergente Líquido',
    description: 'Limpieza profunda, elimina manchas difíciles. Ideal para ropa de color.',
    priceBs: 'Bs 35',
    oldPriceBs: '45 Bs',
    rating: 4.8,
    reviews: 210,
    imageUrl: 'https://placehold.co/300x200/F44336/ffffff?text=Producto+Aseo', // Red image
    badge: 'Oferta 30%',
  ),
];


// --- WIDGETS REUTILIZABLES ---

// 1. Tarjeta de Categoría (con Imagen Circular)
class CategoryChip extends StatelessWidget {
  final Category category;
  final Color primaryColor;

  const CategoryChip({
    super.key,
    required this.category,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Ancho fijo de la tarjeta
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen/Icono Circular
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.network(
              category.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.shopping_basket_rounded, size: 50, color: primaryColor), // Fallback
            ),
          ),
          const SizedBox(height: 8),
          
          // Título
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              category.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Tarjeta de Producto (Promociones/Destacados)
class ProductCard extends StatelessWidget {
  final Product product;
  final Color primaryColor;

  const ProductCard({
    super.key,
    required this.product,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // Ancho de la tarjeta
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Imagen del Producto con Insignia de Descuento
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                child: Image.network(
                  product.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey.shade200,
                    child: Center(child: Icon(Icons.image_not_supported_rounded, color: primaryColor)),
                  ),
                ),
              ),
              // Insignia de Promoción (Top Right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400, // Un tono de rojo más claro para la insignia
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product.badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // 2. Detalles del Producto
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                
                // Rating (Estrellas y Conteo)
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating} (${product.reviews})',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Precio y Botón Agregar (Fila)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.priceBs,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          product.oldPriceBs,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          'por Kg',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    
                    // Botón + Agregar
                    InkWell(
                      onTap: () {
                        // Lógica para añadir al carrito
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black, // Botón negro como en Figma
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// --- PANTALLA PRINCIPAL ---

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.red.shade700;

    // Esta es la barra superior personalizada de tu diseño (Búsqueda y Correo)
    Widget _buildHeader() {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 4.0),
        child: Column(
          children: [
            // Iconos Superiores (Correo, Perfil, Carrito)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.mail_outline_rounded, color: primaryColor), // Correo
                Row(
                  children: [
                    Icon(Icons.person_rounded, color: Colors.grey.shade600), // Perfil
                    const SizedBox(width: 12),
                    Icon(Icons.shopping_cart_rounded, color: Colors.grey.shade600), // Carrito
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),

            // Barra de Búsqueda (Input redondeado)
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: Icon(Icons.search, color: primaryColor.withOpacity(0.6)),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    // Título de Sección
    Widget _buildSectionTitle(String title, {String? subtitle}) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.grey.shade800,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      );
    }


    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(), // Barra superior de búsqueda y notificaciones
              
              // SECCIÓN DE CATEGORÍAS
              _buildSectionTitle('Categorías'),
              SizedBox(
                height: 100, 
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return CategoryChip(category: category, primaryColor: primaryColor);
                  },
                ),
              ),
              const SizedBox(height: 24),

              // SECCIÓN DE PROMOCIONES
              _buildSectionTitle('Promociones'),
              SizedBox(
                height: 300, 
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return ProductCard(product: product, primaryColor: primaryColor);
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // SECCIÓN DE PRODUCTOS DESTACADOS
              _buildSectionTitle(
                'Productos Destacados', 
                subtitle: 'Los mejores productos seleccionados para ti',
              ),
              SizedBox(
                height: 300, 
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    // Usamos el mismo modelo de producto para el ejemplo
                    final product = _products[index]; 
                    return ProductCard(product: product, primaryColor: primaryColor);
                  },
                ),
              ),
              const SizedBox(height: 40), // Espacio inferior para el NavBar flotante
            ],
          ),
        ),
      ),
    );
  }
}
