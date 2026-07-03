import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.60),
      shape: const CircleBorder(),
      elevation: 3,
      child: IconButton(
        constraints: const BoxConstraints(
          minWidth:32,
          minHeight: 32,
        ),
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: Colors.black87,
          size: 22,
        ),
        onPressed: onPressed,
      ),
    );
  }
}