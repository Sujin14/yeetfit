// features/dashboard/presentation/widgets/dashboard_body.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/drag_handle.dart';
import '../../../../utils/fixed_sizes.dart';
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
      padding: EdgeInsets.symmetric(
        horizontal: FixedSizes.box16(context),
        vertical: FixedSizes.box8(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DragHandle(),
          progressAsync.when(
            data: (progress) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pass progress down to MealTrackingCard to avoid re-watching provider inside it
                  MealTrackingCard(progress: progress, userId: userId),
                  SizedBox(height: FixedSizes.box16(context)),
                  ProgressCardsList(progress: progress, userId: userId),
                ],
              );
            },
            loading: () => Column(
              children: [
                MealTrackingCard.loading(userId: userId),
                SizedBox(height: FixedSizes.box16(context)),
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
