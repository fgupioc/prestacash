import 'package:flutter/material.dart';
import 'package:prestacash/features/auth/data/services.dart';
import 'package:prestacash/models/cuota.dart';
import 'package:prestacash/screens/manage_loan_screen.dart';
import 'package:prestacash/screens/register_pay_screen.dart';
import 'package:prestacash/widgets/build_skeleton.dart';

import '../core/constants.dart';
import '../core/enum/LoanStatus.dart';
import '../core/formatters.dart';
import '../models/loan.dart';
import '../widgets/app_bar_nav.dart';
import '../widgets/build_status_badge.dart';
import '../widgets/my_alert.dart';
import '../widgets/my_loader.dart';

class LoanDetailsScreen extends StatefulWidget {
  final Loan loan;

  const LoanDetailsScreen({super.key, required this.loan});

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  final items = [];
  List<Cuota> _cuotas = [];
  bool _loaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCuotas());
  }

  Future<void> _loadCuotas({bool showLoader = true}) async {
    if (showLoader) MyLoader.show(context, message: 'Cargando cuotas...');
    try {
      final cuotas = await loanService.getCuotas(widget.loan.id);
      if (!mounted) return;

      setState(() {
        _cuotas = cuotas;
        _error = null;
        _loaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loaded = true;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (showLoader && mounted) MyLoader.hide(context);
    }
  }

  Future<void> _refresh() => _loadCuotas(showLoader: false);

  Future<void> _cancelLoan({required int loanId}) async {
    final ok = await MyAlert.confirm(
      context,
      title: '¿Seguro que deseas cancelar el préstamo?',
      text: 'Esta acción no se puede deshacer.',
    );
    if (!ok) return;

    MyLoader.show(context, message: 'Cancelando préstamo...');
    try {
      final loan = await loanService.cancel(loanId);
      if (!mounted) return;
      MyLoader.hide(context);
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) MyLoader.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNav(title: 'Detalles del Préstamo'),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.azulMarino.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.azulMarino.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.loan.customer?.name ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.azulNoche,
                            ),
                          ),
                          Text(
                            widget.loan.customer?.phone ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.azulNoche,
                            ),
                          ),
                        ],
                      ),
                      BuildStatusBadge(status: widget.loan.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monto del Préstamo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.azulNoche,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            currencyFormatWithSymbol.format(widget.loan.amount),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.azulNoche,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Fecha de Solicitud',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.azulNoche,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.loan.loanDate ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.azulNoche,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Cuotas del préstamo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.azulMarino,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: _buildList()),
                ],
              ),
            ),
          ),
          if (widget.loan.status != LoanStatus.cancelled) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final created = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPayScreen(loan: widget.loan),
                          ),
                        );
                        if (created == true) {
                          _refresh();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55.0),
                        foregroundColor: AppColors.azulNoche,
                        side: const BorderSide(color: AppColors.azulNoche, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Registrar pago'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageLoanScreen(loan: widget.loan),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(55.0),
                        backgroundColor: AppColors.azulNoche,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Editar préstamo'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        _cancelLoan(loanId: widget.loan.id);
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(55.0),
                        backgroundColor: AppColors.abaco,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Cancelar préstamo'),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Container _buildContainer(Cuota cuota) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.azulMarino.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${cuota.cuota}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.azulNoche,
            ),
          ),
          Text(
            '${cuota.dueDate}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray,
            ),
          ),
          Text(
            '${currencyFormat.format(cuota.amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray,
            ),
          ),
          BuildStatusBadge(status: cuota.status),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (!_loaded) {
      return BuildSkeleton();
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.azulMarino),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: () => _loadCuotas(), child: const Text('Reintentar')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: AppColors.azulMarino,
      child: _cuotas.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 80),
                Center(child: Text('No hay cuotas registradas')),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _cuotas.length,
              itemBuilder: (context, index) => _buildContainer(_cuotas[index]),
            ),
    );
  }
}
