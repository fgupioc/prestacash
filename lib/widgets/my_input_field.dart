import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';
class MyInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final bool hasError;
  final String? Function(String?)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool enabled;

  const MyInputField({
    super.key,
    this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.prefix,
    this.suffix,
    this.hasError = false,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
  });

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
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      enabled: enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        prefixIconColor: hasError ? errorColor : null,
        counterText: '', // oculta el contador "0/8" que agrega maxLength
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