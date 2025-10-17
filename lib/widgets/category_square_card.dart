import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar una tarjeta de categoría cuadrada.
/// Si se pasa [icon] se muestra el icono, si se pasa [imageUrl] se muestra la imagen.
class CategorySquareCard extends StatelessWidget {
  final String title;
  final Color primaryColor;
  final String? imageUrl;
  final IconData? icon;
  final Color? iconColor;
  final Color? circleBackground;

  const CategorySquareCard({
    super.key,
    required this.title,
    required this.primaryColor,
    this.imageUrl,
    this.icon,
    this.iconColor,
    this.circleBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (circleBackground ?? primaryColor.withOpacity(0.08)),
              shape: BoxShape.circle,
            ),
            child: imageUrl != null
                ? ClipOval(
                    child: imageUrl!.startsWith('http') 
                      ? Image.network(
                          imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.shopping_basket_rounded, size: 32, color: primaryColor),
                        )
                      : Image.asset(
                          imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.shopping_basket_rounded, size: 32, color: primaryColor),
                        ),
                  )
                : Icon(
                    icon ?? Icons.category,
                    color: iconColor ?? primaryColor,
                    size: 30,
                  ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
