import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prestacash/core/constants.dart';
import 'package:prestacash/loan_req_dto.dart';
import 'package:prestacash/models/customer.dart';
import 'package:prestacash/widgets/app_bar_nav.dart';
import 'package:prestacash/widgets/my_alert.dart';
import 'package:prestacash/widgets/my_input_field.dart';
import 'package:prestacash/widgets/my_label_field.dart';

import '../core/formatters.dart';
import '../features/auth/data/services.dart';
import '../widgets/my_date_field.dart';
import '../widgets/my_loader.dart';
import '../widgets/my_socio_select.dart';
import '../widgets/my_switch_field.dart';
import 'manage_customer_screen.dart';

class ManageLoanScreen extends StatefulWidget {
  const ManageLoanScreen({super.key});

  @override
  State<ManageLoanScreen> createState() => _ManageLoanScreenState();
}

class _ManageLoanScreenState extends State<ManageLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _interestCtrl = TextEditingController();
  final _dateInitCtrl = TextEditingController();
  final _plazoCtrl = TextEditingController();
  bool get _isEdit => false;
  bool _saving = false;
  bool _selectingCustomer = true;

  Customer? socioSeleccionado;
  DateTime? _fechaPago = DateTime.now();
  String? _formaPago;
  bool _aplicaInteres = true;

  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _dateInitCtrl.text = MyDateField.format(_fechaPago!);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCustomers());
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _interestCtrl.dispose();
    _dateInitCtrl.dispose();
    _plazoCtrl.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null;

  Future<void> _loadCustomers() async {
    try {
      // Simulación de carga de clientes
      final data = await customerService.getCustomers();
      setState(() {
        _customers = data;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        // Manejo de error
      });
    }
  }

  Future<void> _refreshCustomers() => _loadCustomers();

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (socioSeleccionado == null) {
      setState(() {
        _selectingCustomer = false;
      });
    }

    if (!_formKey.currentState!.validate()) return;


    setState(() => _saving = true);

    MyLoader.show(
      context,
      message: _isEdit ? 'Actualizando préstamo...' : 'Registrando préstamo...',
    );
    setState(() => _saving = false);

    LoanReqDto loanSave = LoanReqDto(
      customerId: socioSeleccionado!.id,
      amount: double.parse(_amountCtrl.text.trim()),
      interest: double.parse(_interestCtrl.text.trim()),
      initDate: formatDate(_dateInitCtrl.text),
      plazo: int.parse(_plazoCtrl.text.trim()),
      aplicacionInterest: _aplicaInteres,
    );

    try {
      await loanService.create(loanSave);

      if (!mounted) return;
      MyLoader.hide(context);
      await MyAlert.success(context,  'Préstamo registrado correctamente');

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
      appBar: AppBarNav(title: 'Registrar préstamo'),
      backgroundColor: AppColors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.azulMarino.withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.azulMarino,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Datos del préstamo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.azulMarino,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Busca y selecciona un cliente',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.azulAcero,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MySocioSelect(
              socios: _customers,
              onChanged: (socio) {
                setState(() {
                  socioSeleccionado = socio;
                  _selectingCustomer = socio != null;
                });
                if (socio != null) {
                  debugPrint('Socio seleccionado: ${socio.fullName}');
                } else {
                  debugPrint('Socio eliminado');
                }
              },
            ),
            if (_selectingCustomer == false)
              Text('Debe seleccionar un socio para registrar el préstamo', style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageCustomerScreen(),
                      ),
                    );
                    await _refreshCustomers();
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Agregar socio'),
                ),
              ],
            ),
            // if (socioSeleccionado != null) ...[
            if (false) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.celesteClaro.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.azulMarino),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            socioSeleccionado!.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.azulNoche,
                            ),
                          ),
                          Text(
                            'DNI: ${socioSeleccionado!.documentNumber}',
                            style: const TextStyle(color: AppColors.azulAcero),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            MyLabelField(label: 'Monto del préstamo'),
            const SizedBox(height: 4),
            MyInputField(
              hint: 'Ingrese el monto del préstamo',
              controller: _amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                return validateAmount(v);
              },
            ),
            const SizedBox(height: 16),
            MyLabelField(label: 'Interés(%)'),
            const SizedBox(height: 4),
            MyInputField(
              hint: 'Ingrese el interés',
              controller: _interestCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                return validateAmount(v);
              },
            ),
            const SizedBox(height: 16),
            MySwitchField(
              label: '¿Aplica interés?',
              value: _aplicaInteres,
              onChanged: (v) => setState(() => _aplicaInteres = v),
            ),
            const SizedBox(height: 16),
            MyLabelField(label: 'Fecha de inicio'),
            const SizedBox(height: 4),
            MyDateField(
              hint: 'Selecciona una fecha',
              controller: _dateInitCtrl,
              value: _fechaPago,
              onChanged: (d) => setState(() => _fechaPago = d),
              validator: (v) => (v == null || v.isEmpty) ? 'Selecciona una fecha' : null,
            ),
            const SizedBox(height: 16),
            MyLabelField(label: 'Plazo(meses)'),
            const SizedBox(height: 4),
            MyInputField(
              controller: _plazoCtrl,
              hint: 'Plazo (meses)',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (_required(v) != null) return 'Ingrese el plazo en meses';
                final plazo = int.tryParse(v!.trim());
                if (plazo == null) return 'Solo números enteros, sin decimales';
                if (plazo <= 0) return 'El plazo debe ser mayor a 0';
                return null;
              },
            ),
            SizedBox(height: 12),
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
    );
  }
}
