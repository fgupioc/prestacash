import 'package:flutter/material.dart';

import '../core/constants.dart';

class MySelectField<T> extends StatelessWidget {
  final String hint;
  final List<T> items;
  final T? value;
  final String Function(T item) itemLabel;
  final ValueChanged<T?>? onChanged;
  final Widget? prefix;

  const MySelectField({
    super.key,
    required this.hint,
    required this.items,
    required this.itemLabel,
    this.value,
    this.onChanged,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppInput.height,
      padding: EdgeInsets.only(left: prefix == null ? 16 : 0, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppInput.radius),
        boxShadow: const [AppShadow.soft],
      ),
      child: Row(
        children: [
          if (prefix != null) prefix!,
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                hint: Text(
                  hint,
                  style: const TextStyle(color: AppColors.azulMarino),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.azulMarino,
                ),
                borderRadius: BorderRadius.circular(AppInput.radius),
                dropdownColor: Colors.white,
                items: items
                    .map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}