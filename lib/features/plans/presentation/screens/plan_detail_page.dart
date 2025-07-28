import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../explore/presentation/providers/explore_providers.dart';
import '../../data/models/plan_model.dart';
import '../widgets/plan_details_display.dart';

class PlanDetailPage extends ConsumerWidget {
  final Map<String, dynamic> extra;

  const PlanDetailPage({super.key, required this.extra});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = extra['plan'] as PlanModel;
    final category = extra['category'] as String?;
    final onUnfavorite = extra['onUnfavorite'] as VoidCallback?;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Error',
            style: AppTheme.textStyles['body']?.copyWith(
              color: AppTheme.colors['primaryText'] ?? Colors.black,
            ),
          ),
        ),
        body: Center(
          child: Text(
            'User not logged in',
            style: AppTheme.textStyles['body']?.copyWith(
              color: AppTheme.colors['error'] ?? Colors.red,
              fontSize: 16.sp,
            ),
          ),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(category == 'diet' ? 'diets' : 'workouts')
          .doc(plan.id)
          .snapshots(),
      builder: (context, snapshot) {
        PlanModel updatedPlan = plan;
        if (snapshot.hasData && snapshot.data != null) {
          updatedPlan = PlanModel.fromFirestore(snapshot.data!);
        }

        return YoutubePlayerScaffold(
          controller: YoutubePlayerController(),
          builder: (context, child) => Scaffold(
            appBar: CustomAppBar(
              title: updatedPlan.title,
              showSettings: true,
              onSettings: () => context.push('/settings'),
              showFavorite: true,
              isFavorite: updatedPlan.isFavorite,
              favoriteColor: updatedPlan.isFavorite 
                  ? AppTheme.colors['favorite'] ?? Colors.red 
                  : AppTheme.colors['secondaryText'] ?? Colors.grey,
              onFavorite: () async {
                try {
                  await ref
                      .read(toggleFavoriteUseCaseProvider)
                      .execute(
                        updatedPlan.id!,
                        updatedPlan.type,
                        !updatedPlan.isFavorite,
                      );
                  ref.invalidate(dietPlanProvider);
                  ref.invalidate(workoutPlanProvider);
                  ref.invalidate(favoritePlansProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        updatedPlan.isFavorite
                            ? 'Removed from favorites'
                            : 'Added to favorites',
                        style: AppTheme.textStyles['body']?.copyWith(
                          color: AppTheme.colors['primaryText'] ?? Colors.black,
                        ) ?? const TextStyle(color: Colors.black),
                      ),
                      backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.blue,
                    ),
                  );
                  if (!updatedPlan.isFavorite && onUnfavorite != null) {
                    onUnfavorite();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().contains('PERMISSION_DENIED')
                            ? 'Permission denied: Only admins can update plans'
                            : 'Error: $e',
                        style: AppTheme.textStyles['body']?.copyWith(
                          color: AppTheme.colors['primaryText'] ?? Colors.black,
                        ) ?? const TextStyle(color: Colors.black),
                      ),
                      backgroundColor: AppTheme.colors['error'] ?? Colors.red,
                    ),
                  );
                }
              },
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (updatedPlan.assignedBy != null) ...[
                      Text(
                        'Assigned by: ${updatedPlan.assignedBy}',
                        style: AppTheme.textStyles['body']?.copyWith(
                          color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                          fontSize: 14.sp,
                        ) ?? TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 8.h),
                    ],
                    Expanded(
                      child: PlanDetailsDisplay(
                        plan: updatedPlan,
                        category: category,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}