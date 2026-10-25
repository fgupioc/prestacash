import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';
import 'package:prestacash/widgets/my_button.dart';
import 'package:prestacash/widgets/my_input_field.dart';
import 'package:prestacash/widgets/my_label_field.dart';

import '../features/auth/data/services.dart';
import '../widgets/my_alert.dart';
import '../widgets/my_loader.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  String? _emailError;
  String? _passError;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(() {
      if (_emailError != null && _emailCtrl.text.isNotEmpty) {
        setState(() => _emailError = null);
      }
    });
    _passCtrl.addListener(() {
      if (_passError != null && _passCtrl.text.isNotEmpty) {
        setState(() => _passError = null);
      }
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    setState(() {
      _emailError = email.isEmpty ? 'El correo es obligatorio' : null;
      _passError = pass.isEmpty ? 'La contraseña es obligatoria' : null;
    });

    if (_emailError != null || _passError != null) return;

    MyLoader.show(context, message: 'Iniciando sesión...');
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    try {
      await authService.login(email, pass);
      if (!mounted) return;
      MyLoader.hide(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      MyLoader.hide(context);
      MyAlert.error(
        context,
        'Error al iniciar sesión',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _fieldError(String? error) {
    if (error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs, left: 4),
      child: Text(
        error,
        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.red.shade700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.azulMarino,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.xxxl,
                bottom: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset('assets/images/money.png', width: 200)],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Prestacash',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Inicia sesión para continuar',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.white.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.xxl),
                    topRight: Radius.circular(AppRadius.xxl),
                  ),
                  boxShadow: [AppShadow.soft],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    const MyLabelField(label: 'Correo electrónico'),
                    const SizedBox(height: AppSpacing.xs),
                    MyInputField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'Ingresa tu correo electrónico',
                      prefix: const Icon(Icons.email),
                      hasError: _emailError != null,
                    ),
                    _fieldError(_emailError),
                    const SizedBox(height: AppSpacing.md),
                    const MyLabelField(label: 'Contraseña'),
                    const SizedBox(height: AppSpacing.xs),
                    MyInputField(
                      controller: _passCtrl,
                      hint: 'Ingresa tu contraseña',
                      obscureText: _obscure,
                      prefix: const Icon(Icons.lock),
                      suffix: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      hasError: _passError != null,
                    ),
                    _fieldError(_passError),
                    const SizedBox(height: AppSpacing.lg),
                    MyButton(
                      title: _loading ? 'Ingresando...' : 'Iniciar sesión',
                      onPressed: _onLogin,
                      enabled: !_loading,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
