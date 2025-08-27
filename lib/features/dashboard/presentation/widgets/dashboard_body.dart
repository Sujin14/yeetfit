import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/drag_handle.dart';
import '../providers/dashboard_provider.dart';
import 'progress_card_list.dart';
import 'meal_tracking_card.dart';

class DashboardBody extends ConsumerWidget {
  final String userId;

  const DashboardBody({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(dailyProgressStreamProvider(userId));


    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragHandle(),
            progressAsync.when(
              data: (progress) {
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MealTrackingCard(progress: progress, userId: userId),
                    SizedBox(height: 16.h),
                    ProgressCardsList(userId: userId),
                  ],
                );
              },
              loading: () => Column(
                children: [
                  MealTrackingCard.loading(userId: userId),
                  SizedBox(height: 16.h),
                ],
              ),
              error: (error, _) {
                return Center(child: Text('Error: $error'));
              },
            ),
          ],
      ),
    );
  }
}
