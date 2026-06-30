import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

/// Styled radio-button gender selector matching the design reference.
///
/// Displays a filled green circle for selected and an outlined grey
/// circle for unselected — matches the design image exactly.
class GenderSelector extends StatelessWidget {
  final String? selected;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((option) {
        final isSelected = option == selected;
        return GestureDetector(
          onTap: () => onChanged(option),
          child: Padding(
            padding: const EdgeInsets.only(right: 28),
            child: Row(
              children: [
                // Custom radio dot
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFFCCCCCC),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(Icons.check,
                              size: 12, color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  option,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.onBackground,
                    fontWeight:
                        isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
