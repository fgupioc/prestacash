import 'package:flutter/material.dart';

import '../core/constants.dart';

class AppBarNav extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarNav({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child:  AppBar(
        iconTheme: const IconThemeData(color: AppColors.azulNoche),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.azulNoche,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
