import 'package:flutter/material.dart';

import '../core/constants.dart';

class MyDateField extends StatelessWidget {
  final String hint;
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Widget? prefix;

  const MyDateField({
    super.key,
    required this.hint,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.prefix,
  });

  String _format(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  Future<void> _pickDate(BuildContext context) async {
    FocusScope.of(context).unfocus(); // cierra el teclado si estaba abierto
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: firstDate ?? DateTime(now.year - 5),
      lastDate: lastDate ?? DateTime(now.year + 5),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppColors.azulMarino,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppInput.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppInput.radius),
        boxShadow: const [AppShadow.soft],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppInput.radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onChanged == null ? null : () => _pickDate(context),
          child: Padding(
            padding: EdgeInsets.only(left: prefix == null ? 16 : 0, right: 12),
            child: Row(
              children: [
                if (prefix != null) prefix!,
                Expanded(
                  child: Text(
                    value != null ? _format(value!) : hint,
                    style: TextStyle(
                      fontSize: 16,
                      color: value != null ? Colors.black87 : AppColors.azulMarino,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: AppColors.azulMarino,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}