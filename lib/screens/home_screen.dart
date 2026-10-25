import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/loan_model.dart';
import '../widgets/loan_item.dart';
import '../widgets/my_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text(
            'Resumen de tus préstamos',
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
              MyCards(
                icon: Icons.all_inbox_outlined,
                title: 'Subscription',
                amountColor: AppColors.primary,
                value: 'S/ 8,000.00',
              ),
              const SizedBox(width: 16),
              MyCards(
                icon: Icons.clean_hands_outlined,
                title: 'Por cobrar',
                amountColor: AppColors.success,
                value: 'S/ 3,200.00',
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyCards(
                icon: Icons.calendar_month_rounded,
                title: 'Préstamos activos',
                amountColor: AppColors.warning,
                value: '4',
              ),
              const SizedBox(width: 16),
              MyCards(
                icon: Icons.warning,
                title: 'Préstamos vencidos',
                amountColor: AppColors.red,
                value: '1',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Últimos préstamos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.azulMarino,
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: Row(
                  children: [
                    Text(
                      'Ver todos',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 20, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          Divider(color: AppColors.azulMarino.withValues(alpha: 0.2), thickness: 1),
          const SizedBox(height: 12),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ListView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                final item = items[index];
                return LoanItem(loan: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
