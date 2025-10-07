import 'package:flutter/material.dart';
import '../widgets/category_square_card.dart';

// --- MODELOS DE DATOS ---

class ExploreCategory {
  final String title;
  final IconData icon;
  final Color color;

  const ExploreCategory({
    required this.title,
    required this.icon,
    required this.color,
  });
}

// --- DATOS DE EJEMPLO ---

final List<ExploreCategory> _categories = [
  const ExploreCategory(title: 'Frutas y Verduras', icon: Icons.grass_rounded, color: Color(0xFFE57373)), // Rojo suave
  const ExploreCategory(title: 'Carnes y Pescados', icon: Icons.flatware_rounded, color: Color(0xFFF44336)), // Rojo vivo
  const ExploreCategory(title: 'Lácteos y Huevos', icon: Icons.egg_alt_rounded, color: Color(0xFFEF9A9A)), // Rosa claro
  const ExploreCategory(title: 'Panadería', icon: Icons.cake_rounded, color: Color(0xFFFFCC80)), // Naranja pastel
  const ExploreCategory(title: 'Bebidas', icon: Icons.local_drink_rounded, color: Color(0xFF4DB6AC)), // Teal (Contraste)
  const ExploreCategory(title: 'Limpieza', icon: Icons.cleaning_services_rounded, color: Color(0xFFB39DDB)), // Morado
  const ExploreCategory(title: 'Cuidado Personal', icon: Icons.face_retouching_natural_rounded, color: Color(0xFFDCE775)), // Verde lima
  const ExploreCategory(title: 'Congelados', icon: Icons.ac_unit_rounded, color: Color(0xFF90CAF9)), // Azul claro
];

final List<String> _filters = [
  'Más Popular',
  'Mejor Precio',
  'Ofertas Rápidas',
  'Nuevo',
  'Stock Disponible',
];

// --- WIDGETS DE EXPLORACIÓN ---



// Pantalla principal de Explorar
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.red.shade700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Explorar y Buscar',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          // 1. Barra de Búsqueda Fija
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar productos o categorías...',
                prefixIcon: Icon(Icons.search, color: primaryColor.withOpacity(0.6)),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          
          // 2. Fila de Chips de Filtro (Scroll horizontal)
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final isSelected = index == 0; // Para ejemplo, el primer filtro está seleccionado
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    label: Text(_filters[index]),
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
              },
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFFAFAFA)),
          const SizedBox(height: 10),

          // 3. Grilla de Categorías
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 90.0), // Padding para el NavBar
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Dos columnas
                childAspectRatio: 1.2, // Relación de aspecto (un poco más alta que ancha)
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CategorySquareCard(
                  title: category.title,
                  icon: category.icon,
                  iconColor: category.color,
                  circleBackground: category.color.withOpacity(0.1),
                  primaryColor: primaryColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
