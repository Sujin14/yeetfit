import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/weight_provider.dart';

class WeightEntryDialog extends ConsumerStatefulWidget {
  final String userId;

  const WeightEntryDialog({super.key, required this.userId});

  @override
  ConsumerState<WeightEntryDialog> createState() => _WeightEntryDialogState();
}

class _WeightEntryDialogState extends ConsumerState<WeightEntryDialog> {
  final weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentWeight = ref.read(currentWeightProvider(widget.userId)).value ?? 75.0;
    weightController.text = currentWeight.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.colors['white']!,
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Enter Current Weight',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          fontSize: FixedSizes.font18(context),
          color: AppTheme.colors['onSurface'],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: FixedSizes.box16(context)),
          SizedBox(
            width: FixedSizes.box240(context),
            child: TextField(
              controller: weightController,
              decoration: InputDecoration(
                labelText: 'Current Weight (kg)',
                labelStyle: GoogleFonts.roboto(
                  color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                  fontSize: FixedSizes.font14(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FixedSizes.box10(context)),
                  borderSide: BorderSide(
                    color: AppTheme.colors['borderGradientStart']!,
                  ),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.roboto(
                fontSize: FixedSizes.font16(context),
                color: AppTheme.colors['onSurface'],
              ),
            ),
          ),
          SizedBox(height: FixedSizes.box10(context)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font14(context),
              color: AppTheme.colors['onSurface'],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final currentWeight = double.tryParse(weightController.text);
            if (currentWeight != null && currentWeight > 0) {
              ref.read(currentWeightProvider(widget.userId).notifier).updateWeight(currentWeight);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid weight')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.colors['teal']!.withOpacity(0.3),
          ),
          child: Text(
            'Save',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font14(context),
              color: AppTheme.colors['onSurface'],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }
}
