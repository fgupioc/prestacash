import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/loan_model.dart';

class LoanItem extends StatefulWidget {
  final LoanModel loan;
  final VoidCallback? onTap;

  const LoanItem({super.key, required this.loan, this.onTap});

  @override
  State<LoanItem> createState() => _LoanItemState();
}

class _LoanItemState extends State<LoanItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.azulMarino.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.azulMarino.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.azulMarino,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.loan.fullName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.azulMarino,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'S/ ${widget.loan.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.azulMarino,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStatusBadge(widget.loan.status),
                SizedBox(height: 4),
                Text(
                  widget.loan.date,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String label;

    switch (status.toLowerCase()) {
      case 'a':
        badgeColor = AppColors.success;
        label = 'Al día';
        break;
      case 'v':
        badgeColor = AppColors.red;
        label = 'Vencido';
        break;
      default:
        badgeColor = AppColors.secondary;
        label = 'Desconocido';
    }

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
