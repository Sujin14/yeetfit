import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/weight_provider.dart';
import '../../../../shared/theme/theme.dart';

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
    print(
      'WeightEntryDialog: Initializing for userId=${widget.userId}, authUid=${FirebaseAuth.instance.currentUser?.uid}',
    );
    final currentWeight =
        ref.read(currentWeightProvider(widget.userId)).value ?? 75.0;
    print(
      'WeightEntryDialog: Initial currentWeight=$currentWeight for userId=${widget.userId}',
    );
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
          fontSize: 18.sp,
          color: AppTheme.colors['onSurface'],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          SizedBox(
            width: 250.w,
            child: TextField(
              controller: weightController,
              decoration: InputDecoration(
                labelText: 'Current Weight (kg)',
                labelStyle: GoogleFonts.roboto(
                  color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                  fontSize: 14.sp,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: AppTheme.colors['borderGradientStart']!,
                  ),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: GoogleFonts.roboto(
                color: AppTheme.colors['onSurface'],
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            print(
              'WeightEntryDialog: Cancel pressed for userId=${widget.userId}',
            );
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.roboto(
              color: AppTheme.colors['onSurface'],
              fontSize: 14.sp,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final currentWeight = double.tryParse(weightController.text);
            print(
              'WeightEntryDialog: Save pressed for userId=${widget.userId}, currentWeight=$currentWeight',
            );
            if (currentWeight != null && currentWeight > 0) {
              ref
                  .read(currentWeightProvider(widget.userId).notifier)
                  .updateWeight(currentWeight);
              print(
                'WeightEntryDialog: Saving currentWeight for userId=${widget.userId}',
              );
              Navigator.pop(context);
            } else {
              print(
                'WeightEntryDialog: Invalid weight for userId=${widget.userId}',
              );
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
              color: AppTheme.colors['onSurface'],
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    print('WeightEntryDialog: Disposing for userId=${widget.userId}');
    weightController.dispose();
    super.dispose();
  }
}
