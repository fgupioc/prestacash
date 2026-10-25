import 'package:flutter/material.dart';

import '../core/constants.dart';

enum FiltroPrestamo {
  todos('Todos'),
  activos('Activos'),
  pagados('Pagados'),
  vencidos('Vencidos');

  const FiltroPrestamo(this.label);

  final String label;
}

class FilterLoan extends StatelessWidget {
  final FiltroPrestamo seleccionado;
  final ValueChanged<FiltroPrestamo> onChanged;

  const FilterLoan({super.key, required this.seleccionado, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // por si no entran en pantallas chicas
      child: Row(
        children: [
          for (final filtro in FiltroPrestamo.values)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _FiltroItem(
                label: filtro.label,
                activo: filtro == seleccionado,
                onTap: () => onChanged(filtro),
              ),
            ),
        ],
      ),
    );
  }
}

class _FiltroItem extends StatelessWidget {
  const _FiltroItem({required this.label, required this.activo, required this.onTap});

  final String label;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: activo ? AppColors.azulMarino : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
            color: activo ? Colors.white : AppColors.azulMarino,
          ),
        ),
      ),
    );
  }
}
