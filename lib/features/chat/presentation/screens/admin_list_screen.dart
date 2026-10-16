import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/chat_route_constants.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_list_sliver.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class AdminListScreen extends ConsumerWidget {
  const AdminListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admins = ref.watch(adminsProvider);

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            const GlassSliverAppBar(title: 'Choose a Coach'),
            AdminListSliver(
              admins: admins,
              onSelect: (adminId) =>
                  context.push(ChatRouteConstants.chat, extra: adminId),
              onRetry: () => ref.invalidate(adminsProvider),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }
}
