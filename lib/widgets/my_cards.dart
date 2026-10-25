import 'package:flutter/material.dart';

import '../core/animated_pressable.dart';
import '../core/constants.dart';

class MyCards extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color amountColor;
  final VoidCallback? onTap;

  const MyCards({
    super.key,
    required this.icon,
    required this.title,
    required this.amountColor,
    this.onTap,
    this.value = '',
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedPressable(
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: amountColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: amountColor.withValues(alpha: 0.8), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: amountColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: amountColor.withValues(alpha: 0.2), width: 1),
                ),
                child: Icon(icon, color: amountColor, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.azulMarino,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.azulMarino,
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
