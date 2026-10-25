import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final void Function()? onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? AppColors.azulNoche : AppColors.gray),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? AppColors.azulNoche : AppColors.gray,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
