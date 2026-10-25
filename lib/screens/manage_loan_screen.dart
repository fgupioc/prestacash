import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';
import 'package:prestacash/widgets/app_bar_nav.dart';
import 'package:prestacash/widgets/my_input_field.dart';
import 'package:prestacash/widgets/my_label_field.dart';

import '../models/socio.dart';
import '../widgets/my_date_field.dart';
import '../widgets/my_socio_select.dart';
import '../widgets/my_switch_field.dart';

class ManageLoanScreen extends StatefulWidget {
  const ManageLoanScreen({super.key});

  @override
  State<ManageLoanScreen> createState() => _ManageLoanScreenState();
}

class _ManageLoanScreenState extends State<ManageLoanScreen> {
  Socio? socioSeleccionado;
  DateTime? _fechaPago = DateTime.now();
  String? _formaPago;
  bool _aplicaInteres = true;

  final List<Socio> socios = [
    const Socio(id: 1, nombre: 'Carlos Mendoza Torres', dni: '71562438'),
    const Socio(id: 2, nombre: 'Lucía Martínez Gómez', dni: '70894512'),
    const Socio(id: 3, nombre: 'José Ramírez Soto', dni: '72638109'),
    const Socio(id: 4, nombre: 'Ana Rodríguez Chávez', dni: '70382941'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNav(title: 'Registrar préstamo'),
      backgroundColor: AppColors.white,
      body: ListView(
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
            socios: socios,
            onChanged: (socio) {
              setState(() {
                socioSeleccionado = socio;
              });
              if (socio != null) {
                debugPrint('Socio seleccionado: ${socio.nombre}');
              } else {
                debugPrint('Socio eliminado');
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  // Navegar al formulario de socios
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Agregar socio'),
              ),
            ],
          ),
          if (socioSeleccionado != null) ...[
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
                          socioSeleccionado!.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.azulNoche,
                          ),
                        ),
                        Text(
                          'DNI: ${socioSeleccionado!.dni}',
                          style: const TextStyle(color: AppColors.azulAcero),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          MyLabelField(label: 'Monto del préstamo'),
          const SizedBox(height: 4),
          MyInputField(hint: 'Ingrese el monto del préstamo'),
          const SizedBox(height: 16),
          MyLabelField(label: 'Interés'),
          const SizedBox(height: 4),
          MyInputField(hint: 'Ingrese el interés'),
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
            value: _fechaPago,
            onChanged: (d) => setState(() => _fechaPago = d),
          ),
          const SizedBox(height: 16),
          MyLabelField(label: 'Plazo(meses)'),
          const SizedBox(height: 4),
          MyInputField(hint: 'Ingrese el interés'),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(55.0),
                    backgroundColor: AppColors.azulMarino,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
