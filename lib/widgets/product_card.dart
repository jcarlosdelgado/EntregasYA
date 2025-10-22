import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Color primaryColor;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  // Nuevo: ancho opcional para listas horizontales; en grillas se omite.
  final double? width;
  final EdgeInsetsGeometry? margin; 

  const ProductCard({
    super.key,
    required this.product,
    required this.primaryColor,
    this.onTap,
    this.onAddToCart,
    this.width, 
    this.margin, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // ...existing code...
        width: width, // usar ancho solo si se especifica; en grilla será null y usará el ancho de la celda
        margin: margin ?? const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0), // usa el margen pasado o el original
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFFD0D0D0), 
            width: 0.5, 
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // 25% opacity
              offset: const Offset(0, 5), 
              blurRadius: 4, 
              spreadRadius: 0, 
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto con badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: Colors.grey.shade50,
                    child: Image.network(
                      product.imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140,
                        color: Colors.grey.shade100,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: Colors.grey.shade400,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Badge de descuento solo si no está vacío
                if (product.badge.trim().isNotEmpty)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade500,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        product.badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Contenido de la tarjeta
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 6),

                    // Rating con estrellas (envuelto en FittedBox para escalar levemente si falta ancho)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < product.rating.floor()
                                  ? Icons.star_rounded
                                  : (index < product.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                              color: Colors.amber.shade600,
                              size: 16,
                            );
                          }),
                          const SizedBox(width: 6),
                          Text(
                            '(${product.rating})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 8),

                    // Precio, descuento y botón agregar alineados
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Precios y unidad
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Precio principal
                              Text(
                                product.formattedPrice,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFFF6B35),
                                ),
                              ),
                              if (product.hasDiscount)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    product.formattedOldPrice,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              if (product.hasDiscount)
                                const SizedBox(height: 1),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Text(
                                  product.unit,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Botón agregar al carrito (circular, color FF6B35)
                        GestureDetector(
                          onTap: onAddToCart ?? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} agregado al carrito'),
                                duration: const Duration(seconds: 1),
                                backgroundColor: primaryColor,
                              ),
                            );
                          },
                          child: Container(
                            width: 38,
                            height: 38,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6B35),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 5),
                    
                    // Descripción ahora Flexible para evitar overflow vertical
                    Flexible(
                      child: Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Espacio inferior ligeramente reducido
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}