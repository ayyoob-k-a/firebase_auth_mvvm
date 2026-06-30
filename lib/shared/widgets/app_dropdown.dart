import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

/// Styled dropdown matching the app's text field design:
/// grey fill (#F2F2F2), rounded corners, no border, Outfit font.
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hint;
  final ValueChanged<T?> onChanged;
  final String Function(T)? itemLabel;

  const AppDropdown({
    super.key,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.value,
    this.itemLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.subtitle, size: 22),
          hint: Text(
            hint,
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: AppColors.subtitle,
            ),
          ),
          style: GoogleFonts.outfit(
            fontSize: 15,
            color: AppColors.onBackground,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: items.map((item) {
            final label = itemLabel != null
                ? itemLabel!(item)
                : item.toString();
            return DropdownMenuItem<T>(
              value: item,
              child: Text(label,
                  style: GoogleFonts.outfit(
                      fontSize: 15, color: AppColors.onBackground)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
