import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/steps_provider.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class StepsEntryDialog extends ConsumerStatefulWidget {
  final String userId;

  const StepsEntryDialog({super.key, required this.userId});

  @override
  ConsumerState<StepsEntryDialog> createState() => _StepsEntryDialogState();
}

class _StepsEntryDialogState extends ConsumerState<StepsEntryDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final steps = ref.read(stepsCountProvider(widget.userId)).value ?? 0;
    controller.text = steps.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return GlassmorphicContainer(
      color: const Color(0xFFFF5722),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Add Steps Entry',
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
              hintText: 'Enter steps (e.g., 7500)',
              hintStyle: GoogleFonts.roboto(
                color: Colors.white70,
                fontSize: isDesktop ? 14.sp : 16.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
            ),
            keyboardType: TextInputType.number,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: isDesktop ? 14.sp : 16.sp,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: isDesktop ? 14.sp : 16.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final steps = int.tryParse(controller.text);
              if (steps != null && steps >= 0) {
                ref
                    .read(stepsCountProvider(widget.userId).notifier)
                    .addSteps(steps);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid number of steps'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26A69A).withOpacity(0.3),
            ),
            child: Text(
              'Add',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: isDesktop ? 14.sp : 16.sp,
              ),
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
