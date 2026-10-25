import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart'; 

class MyLabelField extends StatelessWidget {
  final String label;

  const MyLabelField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.azulNoche,
        ),
      ),
    );
  }
}
