import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

/// Reusable styled text field matching the design.
///
/// • Background : #F2F2F2 (light grey)
/// • Hint text  : Outfit, #767676
/// • No border  : uses filled decoration
class AppTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final bool showToggle;
  final bool isVisible;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final VoidCallback? onToggleVisibility;

  const AppTextField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.obscureText = false,
    this.showToggle = false,
    this.isVisible = false,
    this.keyboardType = TextInputType.text,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText && !isVisible,
      keyboardType: keyboardType,
      style: GoogleFonts.outfit(
        fontSize: 15,
        color: AppColors.onBackground,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
          fontSize: 15,
          color: AppColors.subtitle,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        suffixIcon: showToggle
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.subtitle,
                  size: 20,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );
  }
}
