import 'package:flutter/material.dart';

/// Paleta base (de más oscuro a más claro).
class AppColors {
  AppColors._();

  // Paleta principal
  static const Color azulNoche = Color(0xFF021024);
  static const Color azulMarino = Color(0xFF052659);
  static const Color azulAcero = Color(0xFF5483B3);
  static const Color azulSuave = Color(0xFF7DA0CA);
  static const Color celesteClaro = Color(0xFFC1E8FF);

  // Colores semánticos

  static const Color tertiary = azulSuave;
  static const Color onTertiary = azulNoche;

  static const Color background = celesteClaro;
  static const Color onBackground = azulNoche;

  static const Color surface = Colors.white;
  static const Color onSurface = azulNoche;

  static const Color primaryContainer = celesteClaro;
  static const Color onPrimaryContainer = azulNoche;

  static const Color secondaryContainer = azulSuave;
  static const Color onSecondaryContainer = azulNoche;



  static const Color error = Color(0xFFB3261E);
  static const Color onError = Colors.white;

  // Colores base
  static const Color blue = Color(0xFF007BFF);
  static const Color indigo = Color(0xFF6610F2);
  static const Color purple = Color(0xFF6F42C1);
  static const Color pink = Color(0xFFE83E8C);
  static const Color red = Color(0xFFDC3545);
  static const Color orange = Color(0xFFFD7E14);
  static const Color yellow = Color(0xFFFFC107);
  static const Color green = Color(0xFF28A745);
  static const Color teal = Color(0xFF20C997);
  static const Color cyan = Color(0xFF17A2B8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFF6C757D);
  static const Color grayDark = Color(0xFF343A40);

  // Colores semánticos
  static const Color primary = Color(0xFF007BFF);
  static const Color secondary = Color(0xFF6C757D);
  static const Color success = Color(0xFF28A745);
  static const Color info = Color(0xFF17A2B8);
  static const Color warning = Color(0xFFFFC107);
  static const Color danger = Color(0xFFDC3545);
  static const Color light = Color(0xFFF8F9FA);
  static const Color dark = Color(0xFF343A40);

  // Colores personalizados
  static const Color tomato = Color(0xFFFF433D);
  static const Color yellowSoft = Color(0xFFFFB347);
  static const Color magenta = Color(0xE5A802A8); // rgba(168, 2, 168, 0.897)
  static const Color lime = Color(0xEE08F850); // rgba(8, 248, 80, 0.932)
  static const Color lightOrange = Color(0xFFFF6215);
  static const Color abaco = Color(0xFF01683D);
}

class AppInput {
  static const height = 55.0;
  static const radius = 8.0;
}

class AppShadow {
  static const soft = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );
}

class AppRadius {
  static const double sm = 4;
  static const double md = 12;
  static const double lg = 20;
  static const double xl = 32;
  static const double xxl = 40;
  static const double button = 8;
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
  static const double xxxl = 48;
}