import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/steps_provider.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsGoalDialog extends ConsumerStatefulWidget {
  final String userId;

  const StepsGoalDialog({super.key, required this.userId});

  @override
  ConsumerState<StepsGoalDialog> createState() => _StepsGoalDialogState();
}

class _StepsGoalDialogState extends ConsumerState<StepsGoalDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final goalSteps = ref.read(stepsGoalProvider(widget.userId)).value ?? 10000;
    controller.text = goalSteps.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Set Steps Goal',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: isDesktop ? 18.sp : 20.sp,
            color: Colors.white,
          ),
        ),
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter goal steps (e.g., 10000)',
              hintStyle: GoogleFonts.roboto(color: Colors.white70, fontSize: isDesktop ? 14.sp : 16.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
            ),
            keyboardType: TextInputType.number,
            style: GoogleFonts.roboto(color: Colors.white, fontSize: isDesktop ? 14.sp : 16.sp),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(color: Colors.white, fontSize: isDesktop ? 14.sp : 16.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newGoal = int.tryParse(controller.text);
              if (newGoal != null && newGoal > 0) {
                ref.read(stepsGoalProvider(widget.userId).notifier).setGoal(newGoal);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid number')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26A69A).withOpacity(0.3),
            ),
            child: Text(
              'Save',
              style: GoogleFonts.roboto(color: Colors.white, fontSize: isDesktop ? 14.sp : 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}