import 'package:flutter/material.dart';

enum AlertType { success, error, warning, info, question }

class MyAlert {
  static Future<bool?> _show(
      BuildContext context, {
        required AlertType type,
        required String title,
        String? text,
        String confirmText = 'Aceptar',
        String? cancelText,
        Color? confirmColor,
        bool dismissible = true,
      }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: dismissible,
      barrierLabel: 'alert',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, _, __) {
        final curve = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: Tween(begin: 0.7, end: 1.0).animate(curve),
          child: FadeTransition(
            opacity: anim,
            child: _AlertCard(
              type: type,
              title: title,
              text: text,
              confirmText: confirmText,
              cancelText: cancelText,
              confirmColor: confirmColor,
            ),
          ),
        );
      },
    );
  }

  // ---------- Alertas simples ----------
  static Future<void> error(BuildContext c, String title, [String? text]) =>
      _show(c, type: AlertType.error, title: title, text: text);

  static Future<void> success(BuildContext c, String title, [String? text]) =>
      _show(c, type: AlertType.success, title: title, text: text);

  static Future<void> warning(BuildContext c, String title, [String? text]) =>
      _show(c, type: AlertType.warning, title: title, text: text);

  static Future<void> info(BuildContext c, String title, [String? text]) =>
      _show(c, type: AlertType.info, title: title, text: text);

  // ---------- Confirmación ----------
  static Future<bool> confirm(
      BuildContext context, {
        required String title,
        String? text,
        String confirmText = 'Aceptar',
        String cancelText = 'Cancelar',
        AlertType type = AlertType.question,
        Color? confirmColor,
      }) async {
    final result = await _show(
      context,
      type: type,
      title: title,
      text: text,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmColor: confirmColor,
    );
    return result ?? false; // tocar afuera = cancelar
  }
}

class _AlertCard extends StatelessWidget {
  final AlertType type;
  final String title;
  final String? text;
  final String confirmText;
  final String? cancelText;
  final Color? confirmColor;

  const _AlertCard({
    required this.type,
    required this.title,
    this.text,
    required this.confirmText,
    this.cancelText,
    this.confirmColor,
  });

  // Colores de SweetAlert2
  Color get _color => switch (type) {
    AlertType.success => const Color(0xFFA5DC86),
    AlertType.error => const Color(0xFFF27474),
    AlertType.warning => const Color(0xFFF8BB86),
    AlertType.info => const Color(0xFF3FC3EE),
    AlertType.question => const Color(0xFF87ADBD),
  };

  IconData get _icon => switch (type) {
    AlertType.success => Icons.check_rounded,
    AlertType.error => Icons.close_rounded,
    AlertType.warning => Icons.priority_high_rounded,
    AlertType.info => Icons.info_outline_rounded,
    AlertType.question => Icons.question_mark_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (_, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _color.withValues(alpha: 0.4),
                      width: 4,
                    ),
                  ),
                  child: Icon(_icon, color: _color, size: 52),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF545454),
                ),
              ),
              if (text != null) ...[
                const SizedBox(height: 10),
                Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: Color(0xFF545454),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _button(
                    context,
                    label: confirmText,
                    color: confirmColor ?? const Color(0xFF7066E0),
                    value: true,
                  ),
                  if (cancelText != null) ...[
                    const SizedBox(width: 10),
                    _button(
                      context,
                      label: cancelText!,
                      color: const Color(0xFF6E7881),
                      value: false,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(
      BuildContext context, {
        required String label,
        required Color color,
        required bool value,
      }) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 15),
      ),
    );
  }
}