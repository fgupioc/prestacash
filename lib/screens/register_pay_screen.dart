import 'package:flutter/material.dart';
import 'package:prestacash/models/loan.dart';
import 'package:prestacash/models/payment.dart';
import 'package:prestacash/widgets/my_input_field.dart';
import 'package:prestacash/widgets/my_label_field.dart';
import 'package:prestacash/widgets/my_loader.dart';

import '../core/constants.dart';
import '../core/enum/PaymentType.dart';
import '../core/formatters.dart';
import '../features/auth/data/services.dart';
import '../widgets/app_bar_nav.dart';
import '../widgets/build_status_badge.dart';
import '../widgets/my_alert.dart';
import '../widgets/my_date_field.dart';
import '../widgets/my_select_field.dart';

class RegisterPayScreen extends StatefulWidget {
  final Loan loan;

  const RegisterPayScreen({super.key, required this.loan});

  @override
  State<RegisterPayScreen> createState() => _RegisterPayScreenState();
}

class _RegisterPayScreenState extends State<RegisterPayScreen> {
  DateTime? _fechaPago = DateTime.now();
  String? _formaPago = PaymentType.YAPE.label;
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _dateInitCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _saving = false;

  final _formasPago = PaymentType.values.map((e) => e.label).toList();

  @override
  void initState() {
    super.initState();
    _dateInitCtrl.text = MyDateField.format(_fechaPago!);
    _amountCtrl.text = calcularMontoAPagar(
      widget.loan.amount,
      widget.loan.interest,
    ).toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _dateInitCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    MyLoader.show(context, message: 'Registrando pago...');

    setState(() => _saving = false);

    if (!mounted) return;

    PaymentType _paymentType = PaymentType.values.firstWhere((e) => e.label == _formaPago);

    Payment save = Payment(
      loanId: widget.loan.id,
      amount: double.parse(_amountCtrl.text),
      paymentDate: formatDate(_dateInitCtrl.text),
      paymentType: _paymentType.name,
      observations: _noteCtrl.text,
    );

    try {
      await paymentService.create(save);

      if (!mounted) return;
      MyLoader.hide(context);
      await MyAlert.success(context,  'Pago registrado correctamente');

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      MyLoader.hide(context);
      MyAlert.error(context, e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarNav(title: 'Registrar Pago Cuota'),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardInfo(widget.loan),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyLabelField(label: 'Monto a pagar S/'),
                      const SizedBox(height: 4),
                      MyInputField(
                        hint: 'Ingrese el monto del préstamo',
                        controller: _amountCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (v) {
                          return validateAmount(v);
                        },
                      ),
                      const SizedBox(height: 16),
                      MyLabelField(label: 'Fecha de pago'),
                      const SizedBox(height: 4),
                      MyDateField(
                        hint: 'Selecciona una fecha',
                        controller: _dateInitCtrl,
                        value: _fechaPago,
                        onChanged: (d) => setState(() => _fechaPago = d),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Selecciona una fecha' : null,
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
                      MyLabelField(label: 'Nota(opcional)'),
                      const SizedBox(height: 4),
                      MyInputField(hint: 'Escribe una nota', controller: _noteCtrl),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(55.0),
                        backgroundColor: AppColors.azulMarino,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCardInfo(Loan loan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.azulMarino.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.azulMarino.withValues(alpha: 0.5), width: 1),
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
                    loan.customer?.name ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.azulNoche,
                    ),
                  ),
                ],
              ),
              BuildStatusBadge(status: loan.status),
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
                currencyFormatWithSymbol.format(loan.amount),
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
                  color: AppColors.info,
                ),
              ),
              Text(
                currencyFormatWithSymbol.format(
                  calcularMontoAPagar(loan.amount, loan.interest),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double calcularMontoAPagar(double monto, double interes) {
    final tasa = interes / 100;
    return monto * tasa;
  }
}
