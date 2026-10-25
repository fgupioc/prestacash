import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';

class MySwitchField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const MySwitchField({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.azulNoche,
                ),
              ),
            ),
            CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.azulMarino,
            ),
          ],
        ),
      ),
    );
  }
}