import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';
import 'package:prestacash/models/loan.dart';
import 'package:prestacash/screens/loan_details_screen.dart';
import 'package:prestacash/widgets/filter_loan.dart';

import '../core/enum/LoanStatus.dart';
import '../features/auth/data/services.dart';
import '../models/loan_model.dart';
import '../widgets/build_skeleton.dart';
import '../widgets/loan_item.dart';
import '../widgets/my_input_field.dart';
import '../widgets/my_loader.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  FiltroPrestamo _filtro = FiltroPrestamo.todos;
  List<Loan> _loans = [];
  bool _loaded = false;
  String? _error;
  final items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLoans());
  }

  Future<void> _loadLoans({bool showLoader = true}) async {
    if (showLoader) MyLoader.show(context, message: 'Cargando préstamos...');
    try {
      final data = await loanService.getLoans();
      if (!mounted) return;
      setState(() {
        _loans = data;
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

  Future<void> _refresh() => _loadLoans(showLoader: false);

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
            /*
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
            */
            child: _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (!_loaded) return BuildSkeleton();

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.azulMarino),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _loadLoans(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: AppColors.azulMarino,
      child: _loans.isEmpty
          ? ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 80),
          Center(child: Text('No hay préstamos registrados')),
        ],
      )
          : ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: _loans.length,
        itemBuilder: (context, index) => _buildContainer(_loans[index]),
      ),
    );

    /*
    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loans.isEmpty) {
      return const Center(child: Text('No hay préstamos disponibles.'));
    }
    final filteredLoans = _loans.where((loan) {
      switch (_filtro) {
        case FiltroPrestamo.todos:
          return true;
        case FiltroPrestamo.activos:
          return loan.status == LoanStatus.pending;
        case FiltroPrestamo.pagados:
          return loan.status == LoanStatus.paid;
        case FiltroPrestamo.vencidos:
          return loan.status == LoanStatus.expired;
      }
    }).toList();
    if (filteredLoans.isEmpty) {
      return const Center(child: Text('No hay préstamos que coincidan con el filtro.'));
    }
    return ListView.builder(
      itemCount: filteredLoans.length,
      itemBuilder: (context, index) {
        final loan = filteredLoans[index];
        return LoanItem(
          loan: loan,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoanDetailsScreen(loan: loan)),
            );
          },
        );
      },
    );

    */
  }

  GestureDetector _buildContainer(Loan item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoanDetailsScreen(loan: item)),
        );
      },
      child: LoanItem(loan: item),
    );
  }
}
