import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  static const _radius = BorderRadius.all(Radius.circular(8));

  static final _cardDecoration = BoxDecoration(
    color: AppColors.white,
    borderRadius: _radius,
    boxShadow: [
      BoxShadow(
        color: AppColors.azulMarino.withValues(alpha: 0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static final _iconDecoration = BoxDecoration(
    color: AppColors.azulNoche.withValues(alpha: 0.1),
    shape: BoxShape.circle,
    border: Border.all(color: AppColors.azulNoche.withValues(alpha: 0.2)),
  );

  static const _labelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.azulMarino,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _cardDecoration,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: _radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: _iconDecoration,
                  child: Icon(icon, color: AppColors.azulNoche, size: 22),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: _labelStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.azulNoche),
              ],
            ),
          ),
        ),
      ),
    );
  }
}