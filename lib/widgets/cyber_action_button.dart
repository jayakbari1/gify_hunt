import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A common action button widget with cyber/tech styling
/// Used for both toggle buttons and action buttons in the app
class CyberActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Widget? trailingWidget; // For switches or other trailing elements

  const CyberActionButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundWithOpacity(0.7),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.primaryWithOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryWithOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isEnabled
                    ? AppColors.primary
                    : AppColors.textPrimaryWithOpacity(0.5),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isEnabled
                      ? AppColors.primary
                      : AppColors.textPrimaryWithOpacity(0.7),
                ),
              ),
              if (trailingWidget != null) ...[
                const SizedBox(width: 8),
                trailingWidget!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}