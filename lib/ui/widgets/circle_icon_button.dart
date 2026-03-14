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
      color: Colors.white.withOpacity(0.60), // ✅ MATCHES back button
      shape: const CircleBorder(),
      elevation: 3,                           // ✅ MATCHES back button
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.black87,
          size: 32,                           // ✅ MATCHES back button
        ),
        onPressed: onPressed,
      ),
    );
  }
}
