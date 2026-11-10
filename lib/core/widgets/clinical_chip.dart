import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ClinicalChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;
  final bool isAlert;
  final IconData? icon;

  const ClinicalChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
    this.isAlert = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = isAlert
        ? AppTheme.slaOverdue
        : (activeColor ?? AppTheme.primaryBlue);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: effectiveActiveColor.withValues(alpha: 0.15),
        highlightColor: effectiveActiveColor.withValues(alpha: 0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? effectiveActiveColor
                : (isAlert
                      ? AppTheme.slaOverdue.withValues(alpha: 0.08)
                      : Colors.white),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? effectiveActiveColor
                  : (isAlert
                        ? AppTheme.slaOverdue.withValues(alpha: 0.4)
                        : AppTheme.borderLight),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: effectiveActiveColor.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: isSelected
                      ? Colors.white
                      : (isAlert
                            ? AppTheme.slaOverdue
                            : AppTheme.textSecondary),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isAlert ? AppTheme.slaOverdue : AppTheme.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
