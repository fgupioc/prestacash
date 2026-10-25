import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';

class MyDateField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Widget? prefix;
  final bool hasError;
  final String? Function(String?)? validator;
  final bool enabled;

  const MyDateField({
    super.key,
    this.controller,
    this.hint,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.prefix,
    this.hasError = false,
    this.validator,
    this.enabled = true,
  });

  static String format(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  Future<void> _pickDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
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
    if (picked != null) {
      controller?.text = format(picked);
      onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Colors.red.shade700;
    final borderColor = hasError ? errorColor : Colors.grey.shade300;
    final focusColor = hasError ? errorColor : AppColors.azulMarino;

    OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );

    return TextFormField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: () => _pickDate(context),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefix,
        prefixIconColor: hasError ? errorColor : null,
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          size: 20,
          color: hasError ? errorColor : AppColors.azulMarino,
        ),
        errorStyle: TextStyle(color: errorColor, fontSize: 12),
        enabledBorder: border(borderColor),
        focusedBorder: border(focusColor, 1.5),
        errorBorder: border(errorColor),
        focusedErrorBorder: border(errorColor, 1.5),
        disabledBorder: border(Colors.grey.shade200),
      ),
    );
  }
}