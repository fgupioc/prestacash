import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';
import 'package:prestacash/screens/login_screen.dart';

import '../features/auth/data/services.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
    //_timer = Timer(const Duration(seconds: 4), () {
    //  Navigator.push(
    //    context,
    //    MaterialPageRoute(builder: (context) => const LoginScreen()),
    //  );
    //});

    _checkSession();
  }

  Future<void> _checkSession() async {
    // Corren en paralelo: la verificación y un tiempo mínimo para mostrar el logo
    final results = await Future.wait([
      authService.isLoggedIn(),
      Future.delayed(const Duration(milliseconds: 1500)),
    ]);
    final loggedIn = results[0] as bool;

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => loggedIn ? const DashboardScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azulMarino,
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.azulNoche.withValues(alpha: 0.4),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.azulNoche.withValues(alpha: 0.4),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Prestacash',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tu solución financiera confiable',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            letterSpacing: 2,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 100,
                      height: 2,
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.surface.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.surface),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
