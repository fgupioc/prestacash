import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/enum/LoanStatus.dart';

class BuildStatusBadge extends StatelessWidget {
  final LoanStatus status;
  const BuildStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (badgeColor, label) = switch (status) {
      LoanStatus.paid      => (AppColors.success, 'Pagado'),
      LoanStatus.expired   => (AppColors.red, 'Vencido'),
      LoanStatus.pending   => (AppColors.warning, 'Pendiente'),
      LoanStatus.cancelled => (AppColors.secondary, 'Cancelado'),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: badgeColor),
      ),
    );
  }
}
