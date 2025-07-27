import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/model/weight_model.dart';
import '../providers/weight_provider.dart';
import '../../../../shared/theme/theme.dart';

class WeightGoalDialog extends ConsumerStatefulWidget {
  final String userId;

  const WeightGoalDialog({super.key, required this.userId});

  @override
  ConsumerState<WeightGoalDialog> createState() => _WeightGoalDialogState();
}

class _WeightGoalDialogState extends ConsumerState<WeightGoalDialog> {
  final goalController = TextEditingController();
  final initialController = TextEditingController();
  DateTime? targetDate;

  @override
  void initState() {
    super.initState();
    print(
      'WeightGoalDialog: Initializing for userId=${widget.userId}, authUid=${FirebaseAuth.instance.currentUser?.uid}',
    );
    final goal =
        ref.read(weightGoalProvider(widget.userId)).value ??
        WeightData(
          date: DateTime.now().toIso8601String().split('T')[0],
          currentWeight: 75.0,
          goalWeight: 70.0,
          initialWeight: 75.0,
        );
    print(
      'WeightGoalDialog: Initial goal for userId=${widget.userId}: goalWeight=${goal.goalWeight}, initialWeight=${goal.initialWeight}, targetDate=${goal.targetDate}',
    );
    goalController.text = goal.goalWeight.toStringAsFixed(1);
    initialController.text = goal.initialWeight.toStringAsFixed(1);
    targetDate = goal.targetDate;
  }

  @override
  Widget build(BuildContext context) {
    print('WeightGoalDialog: Building for userId=${widget.userId}');
    return AlertDialog(
        backgroundColor: AppTheme.colors['white']!,
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Set Weight Goal',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: AppTheme.colors['onSurface'],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 250.w,
              child: TextField(
                controller: goalController,
                decoration: InputDecoration(
                  labelText: 'Goal Weight (kg)',
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
            SizedBox(height: 16.h),
            SizedBox(
              width: 250.w,
              child: TextField(
                controller: initialController,
                decoration: InputDecoration(
                  labelText: 'Initial Weight (kg)',
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
            SizedBox(height: 16.h),
            ListTile(
              title: Text(
                'Target Date',
                style: GoogleFonts.roboto(
                  color: AppTheme.colors['onSurface'],
                  fontSize: 14.sp,
                ),
              ),
              trailing: Text(
                targetDate != null
                    ? '${targetDate!.day}/${targetDate!.month}/${targetDate!.year}'
                    : 'Select Date',
                style: GoogleFonts.roboto(
                  color: AppTheme.colors['onSurface'],
                  fontSize: 14.sp,
                ),
              ),
              onTap: () async {
                print(
                  'WeightGoalDialog: Opening date picker for userId=${widget.userId}',
                );
                final date = await showDatePicker(
                  context: context,
                  initialDate:
                      targetDate ??
                      DateTime.now().add(const Duration(days: 180)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    targetDate = date;
                    print(
                      'WeightGoalDialog: Selected targetDate=$date for userId=${widget.userId}',
                    );
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              print(
                'WeightGoalDialog: Cancel pressed for userId=${widget.userId}',
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
              final goalWeight = double.tryParse(goalController.text);
              final initialWeight = double.tryParse(initialController.text);
              print(
                'WeightGoalDialog: Save pressed for userId=${widget.userId}, goalWeight=$goalWeight, initialWeight=$initialWeight, targetDate=$targetDate',
              );
              if (goalWeight != null &&
                  initialWeight != null &&
                  goalWeight > 0 &&
                  initialWeight > 0) {
                ref
                    .read(weightGoalProvider(widget.userId).notifier)
                    .setGoal(goalWeight, initialWeight, targetDate);
                print(
                  'WeightGoalDialog: Saving goal for userId=${widget.userId}',
                );
                Navigator.pop(context);
              } else {
                print(
                  'WeightGoalDialog: Invalid weights for userId=${widget.userId}',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid weights')),
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
    print('WeightGoalDialog: Disposing for userId=${widget.userId}');
    goalController.dispose();
    initialController.dispose();
    super.dispose();
  }
}
