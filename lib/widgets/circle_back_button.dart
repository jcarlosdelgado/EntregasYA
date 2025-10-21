import 'package:flutter/material.dart';

class CircleBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final Color color;
  final Color iconColor;
  final double elevation;

  const CircleBackButton({
    Key? key,
    this.onTap,
    this.size = 56,
    this.color = const Color(0xFFFF6B35),
    this.iconColor = Colors.white,
    this.elevation = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: elevation,
      shape: const CircleBorder(),
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onTap ?? () => Navigator.of(context).maybePop(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: iconColor,
              size: size * 0.38,
            ),
          ),
        ),
      ),
    );
  }
}
