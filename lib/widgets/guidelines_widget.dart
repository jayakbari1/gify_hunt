import 'package:flutter/material.dart';

class GuidelinesWidget extends StatelessWidget {
  final String title;
  final List<String> guidelines;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double borderRadius;

  const GuidelinesWidget({
    super.key,
    this.title = 'Submission Guidelines',
    required this.guidelines,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.deepPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.deepPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...guidelines.map(
            (guideline) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                guideline,
                style: TextStyle(
                  color: (textColor ?? Colors.white).withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
