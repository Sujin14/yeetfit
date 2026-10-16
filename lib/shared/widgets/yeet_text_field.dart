import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Translucent form field for screens that already sit on the app gradient
/// (no backdrop blur — a flat 8% white fill reads the same and is cheaper).
class YeetTextField extends StatelessWidget {
  static const double _radius = 14;

  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? suffixTooltip;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;

  /// Stronger fill, border and hint for fields placed directly on a photo,
  /// where the default 8% fill is too faint to read.
  final bool onPhoto;

  const YeetTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.suffixTooltip,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.focusNode,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.inputFormatters,
    this.onPhoto = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(_radius);
    final noBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    );

    final hintColor = onPhoto ? colors.textSecondary : colors.textMuted;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: onPhoto ? 0.12 : 0.08),
        borderRadius: radius,
        border: Border.all(
          color: Colors.white.withValues(alpha: onPhoto ? 0.3 : 0.15),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        focusNode: focusNode,
        autofillHints: autofillHints,
        textCapitalization: textCapitalization,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        cursorColor: colors.primary,
        style: textTheme.bodyLarge!.copyWith(color: colors.onBackground),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle: textTheme.bodyMedium!.copyWith(color: hintColor),
          errorStyle: textTheme.bodySmall!.copyWith(color: colors.error),
          border: noBorder,
          enabledBorder: noBorder,
          errorBorder: noBorder,
          focusedBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: colors.primary, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: colors.error, width: 1.2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixIcon: prefixIcon == null
              ? null
              : Icon(prefixIcon, color: colors.textSecondary, size: 20),
          suffixIcon: suffixIcon == null
              ? null
              : IconButton(
                  onPressed: onSuffixTap,
                  tooltip: suffixTooltip,
                  icon: Icon(suffixIcon, color: colors.textSecondary, size: 20),
                ),
        ),
      ),
    );
  }
}
