import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../data/model/admin_model.dart';
import 'admin_list_item.dart';
import 'admin_list_message.dart';
import 'admin_list_shimmer.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class AdminListSliver extends StatelessWidget {
  final AsyncValue<List<AdminModel>> admins;
  final void Function(String adminId) onSelect;
  final VoidCallback onRetry;

  const AdminListSliver({
    super.key,
    required this.admins,
    required this.onSelect,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return switch (admins) {
      AsyncError(:final error) => SliverToBoxAdapter(
        child: YeetErrorState(
          message: 'Failed to load coaches: $error',
          onRetry: onRetry,
        ),
      ),
      AsyncData(:final value) when value.isEmpty => SliverToBoxAdapter(
        child: AdminListMessage(
          message: 'No coaches available right now',
          icon: Icons.person_search_outlined,
          color: colors.textSecondary,
        ),
      ),
      AsyncData(:final value) => SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        sliver: SliverList.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final admin = value[index];
            return AdminListItem(admin: admin, onTap: () => onSelect(admin.id));
          },
        ),
      ),
      _ => const SliverToBoxAdapter(child: AdminListShimmer()),
    };
  }
}
