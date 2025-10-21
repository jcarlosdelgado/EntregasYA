import 'package:flutter/material.dart';

class Select extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const Select({
    super.key,
    required this.title,
    this.icon, // Opcional
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color:
            isSelected
                ? Colors.deepOrange.withOpacity(0.08)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border:
            isSelected
                ? Border.all(
                  color: Colors.deepOrange.withOpacity(0.3),
                  width: 1.5,
                )
                : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: icon != null // Solo muestra si hay icono
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepOrange : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  size: 20,
                ),
              )
            : null,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.deepOrange.shade700 : Colors.black87,
          ),
        ),
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: Colors.deepOrange,
                  size: 20,
                )
              : null,
        onTap: onTap,
      ),
    );
  }
}
