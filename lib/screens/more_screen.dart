import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';
import 'package:prestacash/screens/splash_screen.dart';

import '../features/auth/data/services.dart';
import '../widgets/menu_title.dart';
import '../widgets/my_alert.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Future<void> _onLogout() async {
    /*
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    */
    final ok = await MyAlert.confirm(
      context,
      title: '¿Seguro que deseas cerrar sesión?',
      text: '',
    );

    /*
    final ok = await MyAlert.confirm(
  context,
  title: '¿Eliminar cliente?',
  text: 'Se borrarán también sus préstamos registrados',
  confirmText: 'Sí, eliminar',
  type: AlertType.warning,
  confirmColor: const Color(0xFFD33F49),
);
     */

    if (!ok || !mounted) return;

    await authService.logout(); // borra access y refresh token

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (_) => false, // elimina todas las pantallas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Más opciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.azulMarino,
            ),
          ),
          SizedBox(height: 24),
          MenuTile(icon: Icons.dashboard, label: 'Historial de pagos', onTap: () => {}),
          SizedBox(height: 12),
          MenuTile(
            icon: Icons.list_outlined,
            label: 'Reporte de préstamos',
            onTap: () => {},
          ),
          SizedBox(height: 12),
          MenuTile(icon: Icons.settings, label: 'Configuración', onTap: () => {}),
          SizedBox(height: 12),
          MenuTile(icon: Icons.logout, label: 'Cerrar sesión', onTap: () => _onLogout()),
        ],
      ),
    );
  }
}
