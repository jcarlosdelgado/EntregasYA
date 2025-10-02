import 'package:flutter/material.dart';

// --- MODELOS DE DATOS ---

class Promotion {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color tagColor;
  final String tagText;

  const Promotion({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tagColor,
    required this.tagText,
  });
}

class OfferProduct {
  final String name;
  final String imageUrl;
  final double originalPrice;
  final double offerPrice;
  final String discountTag;

  const OfferProduct({
    required this.name,
    required this.imageUrl,
    required this.originalPrice,
    required this.offerPrice,
    required this.discountTag,
  });
}

// --- DATOS DE EJEMPLO ---

final List<Promotion> _promotions = [
  const Promotion(
    title: '¡50% de Descuento!',
    subtitle: 'En todos los lácteos esta semana.',
    imageUrl: 'https://placehold.co/600x200/F44336/ffffff?text=50%25+OFF',
    tagColor: Color(0xFFE57373),
    tagText: '¡Hot!',
  ),
  const Promotion(
    title: 'Envío Gratis',
    subtitle: 'En compras mayores a Bs 100.00.',
    imageUrl: 'https://placehold.co/600x200/B00020/ffffff?text=DELIVERY+GRATIS',
    tagColor: Color(0xFFFFCC80),
    tagText: 'Ahorra',
  ),
];

final List<OfferProduct> _offerProducts = [
  const OfferProduct(
    name: 'Atún en Lata',
    imageUrl: 'https://placehold.co/100x100/F44336/ffffff?text=Atun',
    originalPrice: 15.0,
    offerPrice: 9.99,
    discountTag: '30%',
  ),
  const OfferProduct(
    name: 'Aceite Vegetal',
    imageUrl: 'https://placehold.co/100x100/B71C1C/ffffff?text=Aceite',
    originalPrice: 35.0,
    offerPrice: 24.99,
    discountTag: '2x1',
  ),
  const OfferProduct(
    name: 'Pañales para Bebé',
    imageUrl: 'https://placehold.co/100x100/FFCDD2/F44336?text=Pañales',
    originalPrice: 80.0,
    offerPrice: 59.99,
    discountTag: '25%',
  ),
  const OfferProduct(
    name: 'Galletas de Vainilla',
    imageUrl: 'https://placehold.co/100x100/D32F2F/ffffff?text=Galletas',
    originalPrice: 12.0,
    offerPrice: 6.0,
    discountTag: '50%',
  ),
];

// --- WIDGETS DE OFERTAS ---

// Tarjeta grande para un producto o promoción
class OfferBannerCard extends StatelessWidget {
  final Promotion promotion;
  final Color primaryColor;

  const OfferBannerCard({
    super.key,
    required this.promotion,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Etiqueta destacada
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: promotion.tagColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    promotion.tagText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  promotion.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promotion.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Imagen de la promoción
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              promotion.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 100,
                color: primaryColor.withOpacity(0.1),
                child: Center(child: Icon(Icons.flash_on, color: primaryColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tarjeta compacta para productos en oferta
class ProductOfferCard extends StatelessWidget {
  final OfferProduct product;
  final Color primaryColor;

  const ProductOfferCard({
    super.key,
    required this.product,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Área de imagen y etiqueta de descuento
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  product.imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 100,
                    color: primaryColor.withOpacity(0.15),
                    child: Center(child: Icon(Icons.shopping_bag_rounded, color: primaryColor)),
                  ),
                ),
              ),
              // Etiqueta de Descuento
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product.discountTag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Información del producto
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
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Precio Original Tachado
                    Text(
                      'Bs ${product.originalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Precio de Oferta (Rojo)
                    Text(
                      'Bs ${product.offerPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

// Pantalla principal de Ofertas
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.red.shade700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Promociones y Ofertas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: primaryColor),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90), // Espacio para el NavBar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Ofertas Exclusivas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            // 1. Banners Deslizables de Promociones
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _promotions.length,
                itemBuilder: (context, index) {
                  return OfferBannerCard(
                    promotion: _promotions[index],
                    primaryColor: primaryColor,
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 2. Selector de Tipos de Oferta (Simulando chips de filtro)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Buscar por Tipo de Oferta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildOfferChip(context, '50% OFF', primaryColor, true),
                  _buildOfferChip(context, '2x1', primaryColor, false),
                  _buildOfferChip(context, 'Liquidación', primaryColor, false),
                  _buildOfferChip(context, 'Envío Gratis', primaryColor, false),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 3. Productos en Oferta
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Productos Destacados en Descuento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250, // Altura suficiente para las tarjetas de producto
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _offerProducts.length,
                itemBuilder: (context, index) {
                  return ProductOfferCard(
                    product: _offerProducts[index],
                    primaryColor: primaryColor,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget helper para los chips de oferta
  Widget _buildOfferChip(BuildContext context, String label, Color primaryColor, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? primaryColor : Colors.grey.shade200,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
