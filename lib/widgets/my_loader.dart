import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';

class MyLoader {
  static bool _isShowing = false;

  static void show(BuildContext context, {String message = 'Cargando...'}) {
    if (_isShowing) return;
    _isShowing = true;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'loader',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => PopScope(
        canPop: false, // bloquea el botón atrás
        child: _LoaderScreen(message: message),
      ),
      transitionBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    );
  }

  static void hide(BuildContext context) {
    if (!_isShowing) return;
    _isShowing = false;
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class _LoaderScreen extends StatelessWidget {
  final String message;
  const _LoaderScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.azulNoche,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/money.png', width: 120),
            const SizedBox(height: 32),
            const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3.5,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}