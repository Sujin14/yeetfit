import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../providers/water_provider.dart';

class WaterProgressCard extends ConsumerWidget {
  const WaterProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) return const SizedBox.shrink();

    final glassesConsumed = ref.watch(
      glassesConsumedProvider(userId).select((value) => value.value ?? 0),
    );
    final goalGlasses = ref.watch(
      waterGoalProvider(userId).select((value) => value.value ?? 8),
    );

    return GlassmorphicContainer(
      color: AppTheme.colors['navBarActive']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$glassesConsumed / $goalGlasses Glasses',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color:
                      AppTheme.colors['primaryText']?.withOpacity(0.7)
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const WaterGoalDialog(),
                ),
                icon: Icon(
                  Icons.edit,
                  size: 20.sp,
                  color:
                      AppTheme.colors['primaryText']?.withOpacity(0.7) ??
                      Colors.grey,
                ),
                tooltip: 'Edit Goal',
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              LinearProgressIndicator(
                value: goalGlasses > 0 ? glassesConsumed / goalGlasses : 0.0,
                minHeight: 18.h,
                borderRadius: BorderRadius.circular(10.r),
                color: AppTheme.colors['aquaBlue'] ?? Colors.blue,
                backgroundColor: Colors.white.withOpacity(0.2),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Text(
                  '${goalGlasses > 0 ? ((glassesConsumed / goalGlasses) * 100).toInt() : 0}%',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: AppTheme.colors['white'] ?? Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WaterGoalDialog extends ConsumerWidget {
  const WaterGoalDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) return const SizedBox.shrink();

    final state = ref.watch(waterGoalDialogStateProvider(userId));

    return AlertDialog(
      title: Text(
        'Edit Water Goal',
        style: GoogleFonts.roboto(
          color: AppTheme.colors['onSurface'],
        ),
      ),
      content: TextField(
        controller: state.controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Glasses per Day',
          hintText: 'Enter number of glasses',
          labelStyle: GoogleFonts.roboto(
            color: AppTheme.colors['onSurface']?.withOpacity(0.7),
          ),
          hintStyle: GoogleFonts.roboto(
            color: AppTheme.colors['onSurface']?.withOpacity(0.5),
          ),
        ),
        style: GoogleFonts.roboto(
          color: AppTheme.colors['onSurface'],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.roboto(
              color: AppTheme.colors['onSurface'],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => state.submitGoal(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.colors['navBarActive'],
          ),
          child: Text(
            'Save',
            style: GoogleFonts.roboto(
              color: AppTheme.colors['white'],
            ),
          ),
        ),
      ],
    );
  }
}
