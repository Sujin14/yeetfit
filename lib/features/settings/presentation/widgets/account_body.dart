import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../../user_info/presentation/providers/user_info_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/basic_info_card.dart';
import '../widgets/food_preferences_card.dart';
import '../widgets/goal_card.dart';
import '../widgets/profile_card.dart';

class AccountBody extends ConsumerWidget {
  const AccountBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userInfoControllerProvider);
    final isSaving = ref.watch(settingsControllerProvider.notifier).isSaving;

    return userDataAsync.when(
      data: (userInfo) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: FixedSizes.box24(context),
          vertical: FixedSizes.box24(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ProfileCard(
                userInfo: userInfo,
                onEdit: () async {
                  final picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null && context.mounted) {
                    await ref.read(settingsControllerProvider.notifier).updateProfileImage(
                          context: context,
                          image: image,
                        );
                  }
                },
              ),
            ),
            SizedBox(height: FixedSizes.box24(context)),
            BasicInfoCard(onTap: () => context.push('/basic-information')),
            SizedBox(height: FixedSizes.box16(context)),
            GoalCard(
              title: 'Fitness Goal',
              selectedGoal: userInfo.goal.isNotEmpty ? userInfo.goal : 'weight loss',
              onGoalSelected: (newGoal) {
                if (newGoal != null) {
                  ref.read(settingsControllerProvider.notifier).updateFitnessGoal(
                        context: context,
                        goal: newGoal,
                      );
                }
              },
            ),
            SizedBox(height: FixedSizes.box16(context)),
            FoodPreferencesCard(onTap: () => context.push('/food-preferences')),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Error: $error',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['primaryText'],
          ),
        ),
      ),
    );
  }
}
