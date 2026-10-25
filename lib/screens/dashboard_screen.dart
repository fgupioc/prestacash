import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prestacash/core/constants.dart';
import 'package:prestacash/screens/customers_screen.dart';
import 'package:prestacash/screens/home_screen.dart';
import 'package:prestacash/screens/loans_screen.dart';
import 'package:prestacash/screens/manage_loan_screen.dart';
import 'package:prestacash/screens/more_screen.dart';
import 'package:prestacash/widgets/my_app_bar.dart';

import '../widgets/my_navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final Set<int> _loaded = {0};

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const LoansScreen();
      case 3:
        return const CustomersScreen();
      case 4:
        return const MoreScreen();
      default:
        return const SizedBox.shrink(); // índice 2: hueco del FAB
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
      _loaded.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        appBar: const MyAppBar(nombre: 'Franz'),
        body: _buildScreen(_currentIndex),
        /*
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(
            5,
                (i) => _loaded.contains(i) ? _buildScreen(i) : const SizedBox.shrink(),
          ),
        ),
        */
        bottomNavigationBar: MyNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
        ),
        floatingActionButton: _fab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ManageLoanScreen()));
      },
      shape: const CircleBorder(),
      backgroundColor: AppColors.azulMarino,
      child: Text(
        '+',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }
}
