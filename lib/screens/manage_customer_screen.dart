import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prestacash/widgets/my_input_field.dart';
import 'package:prestacash/widgets/my_label_field.dart';

import '../core/constants.dart';
import '../features/auth/data/customer_service.dart';
import '../features/auth/data/services.dart';
import '../models/customer.dart';
import '../widgets/app_bar_nav.dart';
import '../widgets/my_alert.dart';
import '../widgets/my_loader.dart';

class ManageCustomerScreen extends StatefulWidget {
  final Customer? customer;
  const ManageCustomerScreen({super.key, this.customer});

  @override
  State<ManageCustomerScreen> createState() => _ManageCustomerScreenState();
}

class _ManageCustomerScreenState extends State<ManageCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _documentCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  late final CustomerService _customerService = CustomerService(apiClient);
  bool _saving = false;
  bool get _isEdit => widget.customer != null;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    if (c != null) {
      _documentCtrl.text = c.documentNumber;
      _nameCtrl.text = c.name;
      _lastNameCtrl.text = c.lastName;
      _phoneCtrl.text = c.phone ?? '';
    }
  }


  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    MyLoader.show(
      context,
      message: _isEdit ? 'Actualizando cliente...' : 'Registrando cliente...',
    );
    final phone = _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim();

    try {
      if (_isEdit) {
        await customerService.updateCustomer(
          id: widget.customer!.id,
          documentType: widget.customer!.documentType,
          documentNumber: _documentCtrl.text.trim(),
          name: _nameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          phone: phone,
          address: widget.customer!.address,
        );
      } else {
        await customerService.createCustomer(
          documentType: 'DNI',
          documentNumber: _documentCtrl.text.trim(),
          name: _nameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          phone: phone,
        );
      }

      if (!mounted) return;
      MyLoader.hide(context);
      await MyAlert.success(
        context,
        _isEdit ? 'Cliente actualizado correctamente' : 'Cliente registrado correctamente',
      );
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

  Future<void> _delete() async {
    final ok = await MyAlert.confirm(
      context,
      title: '¿Seguro que deseas eliminar a ${widget.customer!.fullName}?',
      text: 'Se borrarán también sus préstamos registrados',
      confirmText: 'Sí, eliminar',
      type: AlertType.question,
      confirmColor: const Color(0xFFD33F49)
    );

    if (ok != true || !mounted) return;

    setState(() => _saving = true);
    MyLoader.show(context, message: 'Eliminando cliente...');

    try {
      await customerService.deleteCustomer(widget.customer!.id);

      if (!mounted) return;
      MyLoader.hide(context);
      await MyAlert.success(context, 'Cliente eliminado correctamente');
      if (!mounted) return;
      Navigator.of(context).pop(true); // recarga la lista al volver
    } catch (e) {
      if (!mounted) return;
      MyLoader.hide(context);
      MyAlert.error(context, e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarNav(title: _isEdit ? 'Editar cliente' : 'Registrar cliente'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        MyLabelField(label: 'Número de documento'),
                        const SizedBox(height: 16),
                        MyInputField(
                          hint: 'Ingrese el número de documento del cliente',
                          controller: _documentCtrl,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          enabled: !_isEdit,
                          validator: (v) {
                            if (_required(v) != null) return 'Campo obligatorio';
                            if (!RegExp(r'^\d{8}$').hasMatch(v!.trim())) {
                              return 'El DNI debe tener 8 dígitos';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        MyLabelField(label: 'Nombres'),
                        const SizedBox(height: 16),
                        MyInputField(
                          hint: 'Ingrese los nombres del cliente',
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.words,
                          validator: _required,
                        ),
                        const SizedBox(height: 16),
                        MyLabelField(label: 'Apellidos'),
                        const SizedBox(height: 16),
                        MyInputField(
                          hint: 'Ingrese los apellidos del cliente',
                          controller: _lastNameCtrl,
                          validator: _required,
                        ),
                        const SizedBox(height: 16),
                        MyLabelField(label: 'Teléfono'),
                        const SizedBox(height: 16),
                        MyInputField(
                          hint: 'Ingrese el teléfono del cliente',
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          maxLength: 9,
                          validator: (v) {
                            final t = v?.trim() ?? '';
                            if (t.isEmpty) return null; // opcional
                            if (!RegExp(r'^9\d{8}$').hasMatch(t)) {
                              return 'Debe tener 9 dígitos y empezar con 9';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(55.0),
                        backgroundColor: AppColors.azulMarino,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.azulMarino.withValues(
                          alpha: 0.6,
                        ),
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
                          : Text(_isEdit ? 'Actualizar' : 'Guardar'),
                    ),
                  ),
                  if (_isEdit) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : _delete,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(55.0),
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade700, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        child: const Text('Eliminar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
