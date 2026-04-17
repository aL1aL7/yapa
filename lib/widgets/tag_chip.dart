import 'package:flutter/material.dart';
import '../models/tag.dart';

class TagChip extends StatelessWidget {
  final Tag tag;
  final bool selected;
  final VoidCallback? onTap;

  const TagChip({super.key, required this.tag, this.selected = false, this.onTap});

  Color _parseColor() {
    try {
      final hex = tag.color.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor();
    final isDark = color.computeLuminance() < 0.5;
    final textColor = isDark ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? color : color.withAlpha(40),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: selected ? 0 : 1),
        ),
        child: Text(
          tag.name,
          style: TextStyle(
            fontSize: 12,
            color: selected ? textColor : color,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
