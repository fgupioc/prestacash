import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';


class MyButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool enabled;
  final bool loading;

  const MyButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.enabled = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppInput.height,
      child: ElevatedButton(
        onPressed: (enabled && !loading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.azulMarino,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.azulMarino.withValues(alpha: 0.7),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppInput.radius),
          ),
        ),
        child: loading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
        )
            : Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
