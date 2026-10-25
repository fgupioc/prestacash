import 'package:flutter/material.dart';

import '../core/constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.nombre});

  final String nombre;

  @override
  Size get preferredSize => const Size.fromHeight(72); // 64 toolbar + 8 margen

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: AppBar(
            primary: false,
            toolbarHeight: 64,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 64,
            leading: const Padding(
              padding: EdgeInsets.only(left: 20),
              child: CircleAvatar(
                backgroundColor: AppColors.azulMarino,
                child: Icon(Icons.person, color: AppColors.white, size: 28),
              ),
            ),
            titleSpacing: 12,
            title: Text(
              'Hola, $nombre',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.azulMarino,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.azulMarino,
                  size: 26,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}