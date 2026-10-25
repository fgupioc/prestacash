import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';
import 'package:prestacash/screens/loan_details_screen.dart';
import 'package:prestacash/widgets/filter_loan.dart';

import '../models/loan_model.dart';
import '../widgets/loan_item.dart';
import '../widgets/my_input_field.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  FiltroPrestamo _filtro = FiltroPrestamo.todos;
  final items = [
    LoanModel(fullName: 'Juan Perez', amount: 3200.00, status: 'a', date: '2024/06/01'),
    LoanModel(fullName: 'Maria Lopez', amount: 1500.00, status: 'v', date: '2024/05/15'),
    LoanModel(fullName: 'Luis Ramirez', amount: 4000.00, status: 'a', date: '2024/06/05'),
    LoanModel(fullName: 'Ana Torres', amount: 2500.00, status: 'a', date: '2024/06/10'),
    LoanModel(
      fullName: 'Carlos Mendoza',
      amount: 1800.00,
      status: 'v',
      date: '2024/05/20',
    ),
    LoanModel(fullName: 'Juan Perez', amount: 3200.00, status: 'a', date: '2024/06/01'),
    LoanModel(fullName: 'Maria Lopez', amount: 1500.00, status: 'v', date: '2024/05/15'),
    LoanModel(fullName: 'Luis Ramirez', amount: 4000.00, status: 'a', date: '2024/06/05'),
    LoanModel(fullName: 'Ana Torres', amount: 2500.00, status: 'a', date: '2024/06/10'),
    LoanModel(
      fullName: 'Carlos Mendoza',
      amount: 1800.00,
      status: 'v',
      date: '2024/05/20',
    ),
    LoanModel(fullName: 'Juan Perez', amount: 3200.00, status: 'a', date: '2024/06/01'),
    LoanModel(fullName: 'Maria Lopez', amount: 1500.00, status: 'v', date: '2024/05/15'),
    LoanModel(fullName: 'Luis Ramirez', amount: 4000.00, status: 'a', date: '2024/06/05'),
    LoanModel(fullName: 'Ana Torres', amount: 2500.00, status: 'a', date: '2024/06/10'),
    LoanModel(
      fullName: 'Carlos Mendoza',
      amount: 1800.00,
      status: 'v',
      date: '2024/05/20',
    ),
  ];

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
            'Préstamos',
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
              Expanded(
                child: MyInputField(
                  hint: 'Buscar por nombre',
                  prefix: Icon(Icons.search),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Handle filter action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azulMarino,
                  fixedSize: const Size(AppInput.height, AppInput.height),
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Icon(Icons.filter_list, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilterLoan(
            seleccionado: _filtro,
            onChanged: (f) => setState(() => _filtro = f),
          ),
          const SizedBox(height: 8),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20), // espacio para el FAB
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) => LoanItem(loan: items[index], onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoanDetailsScreen()));
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
