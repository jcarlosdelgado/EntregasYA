import 'package:flutter/material.dart';

// Definición de un elemento de menú
class ProfileMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.red.shade700;
    final Color accentColor = Colors.grey.shade300;

    // Menú de opciones de perfil (simulamos las acciones con SnackBar)
    final List<ProfileMenuItem> menuItems = [
      ProfileMenuItem(
        title: 'Mis Órdenes',
        icon: Icons.receipt_long_rounded,
        onTap: () => _showSnackBar(context, 'Navegando a Historial de Órdenes'),
      ),
      ProfileMenuItem(
        title: 'Direcciones',
        icon: Icons.location_on_rounded,
        onTap: () => _showSnackBar(context, 'Gestionando Direcciones de Envío'),
      ),
      ProfileMenuItem(
        title: 'Métodos de Pago',
        icon: Icons.credit_card_rounded,
        onTap: () => _showSnackBar(context, 'Gestionando Métodos de Pago'),
      ),
      ProfileMenuItem(
        title: 'Notificaciones',
        icon: Icons.notifications_active_rounded,
        onTap: () => _showSnackBar(context, 'Configurando Notificaciones'),
      ),
      ProfileMenuItem(
        title: 'Ayuda y Soporte',
        icon: Icons.help_outline_rounded,
        onTap: () => _showSnackBar(context, 'Accediendo a Soporte'),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showSnackBar(context, 'Editando Perfil'),
            icon: Icon(Icons.settings_rounded, color: primaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90), // Espacio para el NavBar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Cabecera del Usuario
            _buildProfileHeader(primaryColor, accentColor),

            const SizedBox(height: 20),

            // 2. Opciones de Menú (tarjetas elegantes)
            ...menuItems.map((item) => _buildMenuItem(context, item, primaryColor)),
            
            const SizedBox(height: 30),

            // 3. Botón de Cerrar Sesión (Destacado)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showSnackBar(context, 'Cerrando Sesión...'),
                  icon: const Icon(Icons.logout_rounded, size: 24),
                  label: const Text('Cerrar Sesión'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para el encabezado del perfil con Avatar
  Widget _buildProfileHeader(Color primaryColor, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          // Avatar Circular (simulando una imagen)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor,
              border: Border.all(color: primaryColor, width: 3),
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 15),
          // Información del Usuario
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hola, Carlos!', // Nombre de ejemplo
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'carlos@ejemplo.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget para cada ítem de menú (Tile)
  Widget _buildMenuItem(BuildContext context, ProfileMenuItem item, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: ListTile(
        onTap: item.onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item.icon, color: primaryColor, size: 24),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  // Helper para simular navegación
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}
