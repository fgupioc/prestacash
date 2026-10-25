import 'package:flutter/material.dart';
import 'package:prestacash/models/cuota_item.dart';
import 'package:prestacash/screens/manage_loan_screen.dart';
import 'package:prestacash/screens/register_pay.dart';

import '../core/constants.dart';
import '../widgets/app_bar_nav.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({super.key});

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  final items = [
    CuotaItem(cuota: 1, amount: 3200.00, date: '2024-06-01', status: 'Aprobado'),
    CuotaItem(cuota: 2, amount: 3200.00, date: '2024-07-01', status: 'Pendiente'),
    CuotaItem(cuota: 3, amount: 3200.00, date: '2024-08-01', status: 'Pendiente'),
    CuotaItem(cuota: 4, amount: 3200.00, date: '2024-09-01', status: 'Pendiente'),
    CuotaItem(cuota: 5, amount: 3200.00, date: '2024-10-01', status: 'Pendiente'),
    CuotaItem(cuota: 6, amount: 3200.00, date: '2024-11-01', status: 'Pendiente'),
    CuotaItem(cuota: 1, amount: 3200.00, date: '2024-06-01', status: 'Aprobado'),
    CuotaItem(cuota: 2, amount: 3200.00, date: '2024-07-01', status: 'Pendiente'),
    CuotaItem(cuota: 3, amount: 3200.00, date: '2024-08-01', status: 'Pendiente'),
    CuotaItem(cuota: 4, amount: 3200.00, date: '2024-09-01', status: 'Pendiente'),
    CuotaItem(cuota: 5, amount: 3200.00, date: '2024-10-01', status: 'Pendiente'),
    CuotaItem(cuota: 6, amount: 3200.00, date: '2024-11-01', status: 'Pendiente'),
    CuotaItem(cuota: 1, amount: 3200.00, date: '2024-06-01', status: 'Aprobado'),
    CuotaItem(cuota: 2, amount: 3200.00, date: '2024-07-01', status: 'Pendiente'),
    CuotaItem(cuota: 3, amount: 3200.00, date: '2024-08-01', status: 'Pendiente'),
    CuotaItem(cuota: 4, amount: 3200.00, date: '2024-09-01', status: 'Pendiente'),
    CuotaItem(cuota: 5, amount: 3200.00, date: '2024-10-01', status: 'Pendiente'),
    CuotaItem(cuota: 6, amount: 3200.00, date: '2024-11-01', status: 'Pendiente'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNav(title: 'Detalles del Préstamo',),
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
                          const Text(
                            'Juan Perez',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.azulNoche,
                            ),
                          ),
                          const Text(
                            '950016418',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.azulNoche,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Aprobado',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
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
                            '\$3,200.00',
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
                        children: const [
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
                            '2024/06/01',
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
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                          itemCount: items.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) => Container(
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
                                const Text(
                                  '1/6',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.azulNoche,
                                  ),
                                ),
                                const Text(
                                  '12/12/2026',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gray,
                                  ),
                                ),
                                const Text(
                                  '159.20',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gray,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.green.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      'Pendiente',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPay()),
                      );
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ManageLoanScreen()));
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
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
