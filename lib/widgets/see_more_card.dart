import 'package:flutter/material.dart';

class SeeMoreCard extends StatelessWidget {
  final double? width;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const SeeMoreCard({
    super.key,
    this.width,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: margin ?? const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFFD0D0D0),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 5),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.shopping_cart_rounded,
                color: Color(0xFFFF6B35),
                size: 72,
              ),
              SizedBox(height: 16),
              Text(
                'Ver mas\nProductos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF444B54),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
