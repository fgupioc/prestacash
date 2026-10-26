import 'package:flutter/material.dart';
import 'package:prestacash/models/dashboard.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../features/auth/data/services.dart';
import '../models/loan_model.dart';
import '../widgets/loan_item.dart';
import '../widgets/my_cards.dart';
import 'loan_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Dashboard? dashboard;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await dashboardService.getDashboard();
      if (!mounted) return;
      setState(() {
        dashboard = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        _error = msg;
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && dashboard == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dashboard == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error ?? 'No se pudo cargar la información'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadDashboard,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final d = dashboard!;

    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            Text(
              'Resumen de tus préstamos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.azulMarino,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyCards(
                  icon: Icons.all_inbox_outlined,
                  title: 'Monto',
                  amountColor: AppColors.primary,
                  value: '${currencyFormatWithSymbol.format(d.totalPrestado)}',
                ),
                const SizedBox(width: 16),
                MyCards(
                  icon: Icons.clean_hands_outlined,
                  title: 'Por cobrar',
                  amountColor: AppColors.success,
                  value: '${currencyFormatWithSymbol.format(d.totalPorCobrar)}',
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyCards(
                  icon: Icons.calendar_month_rounded,
                  title: 'Préstamos activos',
                  amountColor: AppColors.warning,
                  value: '${d.cantidadPrestamos}',
                ),
                const SizedBox(width: 16),
                MyCards(
                  icon: Icons.warning,
                  title: 'Préstamos vencidos',
                  amountColor: AppColors.red,
                  value: '${d.cantidadVencidos}',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Últimos préstamos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.azulMarino,
                  ),
                ),
                InkWell(
                  onTap: () {
        
                  },
                  child: Row(
                    children: [
                      Text(
                        'Ver todos',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 20, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: AppColors.azulMarino.withValues(alpha: 0.2), thickness: 1),
            const SizedBox(height: 12),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ListView.builder(
                itemCount: d.ultimosPrestamos.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  final item = d.ultimosPrestamos[index];
                  return LoanItem(loan: item, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoanDetailsScreen(loan: item)),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
