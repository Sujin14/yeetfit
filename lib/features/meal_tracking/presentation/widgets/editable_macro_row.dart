import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Label plus a compact numeric field; reports 0 for blank input.
class EditableMacroRow extends StatefulWidget {
  final String label;
  final double initialValue;
  final String unit;
  final Color accentColor;
  final ValueChanged<double> onChanged;

  const EditableMacroRow({
    super.key,
    required this.label,
    required this.initialValue,
    required this.unit,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  State<EditableMacroRow> createState() => _EditableMacroRowState();
}

class _EditableMacroRowState extends State<EditableMacroRow> {
  late final TextEditingController _controller = TextEditingController(
    text: _format(widget.initialValue),
  );

  static String _format(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              widget.label,
              style: textTheme.bodyMedium!.copyWith(color: colors.onSurface),
            ),
          ),
          SizedBox(
            width: 80,
            child: TextFormField(
              controller: _controller,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,5}(\.\d?)?')),
              ],
              style: textTheme.titleMedium!.copyWith(
                color: colors.onBackground,
              ),
              cursorColor: colors.primary,
              decoration: InputDecoration(
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: BorderSide(color: colors.primary),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.08),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                isDense: true,
                suffix: Text(
                  widget.unit,
                  style: textTheme.bodySmall!.copyWith(color: colors.textMuted),
                ),
              ),
              onChanged: (text) => widget.onChanged(double.tryParse(text) ?? 0),
            ),
          ),
        ],
      ),
    );
  }
}
