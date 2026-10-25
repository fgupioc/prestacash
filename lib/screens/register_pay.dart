import 'package:flutter/material.dart';
import 'package:prestacash/widgets/my_input_field.dart';
import 'package:prestacash/widgets/my_label_field.dart';

import '../core/constants.dart';
import '../widgets/app_bar_nav.dart';
import '../widgets/my_date_field.dart';
import '../widgets/my_select_field.dart';

class RegisterPay extends StatefulWidget {
  const RegisterPay({super.key});

  @override
  State<RegisterPay> createState() => _RegisterPayState();
}

class _RegisterPayState extends State<RegisterPay> {
  DateTime? _fechaPago = DateTime.now();
  String? _formaPago;

  final _formasPago = ['Efectivo', 'Yape', 'Plin', 'Transferencia'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarNav(title: 'Registrar Pago Cuota'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Pendiente',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monto Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.azulNoche.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        'S/ 3,200.00',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.azulNoche.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pendiente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.warning,
                        ),
                      ),
                      Text(
                        'S/ 500.00',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyLabelField(label: 'Monto a pagar S/',),
                    const SizedBox(height: 4),
                    MyInputField(hint: 'Ej. 189.00'),
                    const SizedBox(height: 16),
                    MyLabelField(label: 'Fecha de pago'),
                    const SizedBox(height: 4),
                    MyDateField(
                      hint: 'Selecciona una fecha',
                      value: _fechaPago,
                      onChanged: (d) => setState(() => _fechaPago = d),
                    ),
                    const SizedBox(height: 16),
                    MyLabelField(label: 'Forma de pago'),
                    const SizedBox(height: 4),
                    MySelectField<String>(
                      hint: 'Selecciona',
                      items: _formasPago,
                      value: _formaPago,
                      itemLabel: (e) => e,
                      onChanged: (v) => setState(() => _formaPago = v),
                    ),
                    const SizedBox(height: 16),
                    MyLabelField(label: 'Nota(opcional)',),
                    const SizedBox(height: 4),
                    MyInputField(hint: 'Escribe una nota'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle payment registration
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.azulMarino,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Registrar pago',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
