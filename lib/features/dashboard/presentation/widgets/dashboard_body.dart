import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/shared/widgets/drag_handle.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/dashboard_provider.dart';
import 'progress_card_list.dart';
import 'meal_tracking_card.dart';

class DashboardBody extends ConsumerWidget {
  final String userId;

  const DashboardBody({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(dailyProgressStreamProvider(userId));

    print('DashboardBody: Building for userId=$userId');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DragHandle(),
          progressAsync.when(
            data: (progress) {
              print(
                'DashboardBody: Progress data for userId=$userId: $progress',
              );
              if (!(progress['hasData'] ?? false)) {
                return GestureDetector(
                  onTap: () => context.push('/modal/meal', extra: userId),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppTheme.colors['secondaryText']!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'No data added for this day. Tap to add data.',
                      style: AppTheme.textStyles['body']!.copyWith(
                        fontSize: 16.sp,
                        color: AppTheme.colors['primaryText'],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MealTrackingCard(progress: progress, userId: userId),
                  SizedBox(height: 16.h),
                  ProgressCardsList(progress: progress, userId: userId),
                ],
              );
            },
            loading: () => Column(
              children: [
                MealTrackingCard.loading(userId: userId),
                SizedBox(height: 16.h),
                ProgressCardsList.loading(userId: userId),
              ],
            ),
            error: (error, _) {
              print(
                'DashboardBody: Error loading progress for userId=$userId: $error',
              );
              return Center(child: Text('Error: $error'));
            },
          ),
        ],
      ),
    );
  }
}
