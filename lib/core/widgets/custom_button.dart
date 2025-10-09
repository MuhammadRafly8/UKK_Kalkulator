
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final bool isDoubleWidth;
  final bool isDoubleHeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.isDoubleWidth = false,
    this.isDoubleHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: isDoubleWidth ? null : double.infinity,
        height: isDoubleHeight ? null : double.infinity,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}