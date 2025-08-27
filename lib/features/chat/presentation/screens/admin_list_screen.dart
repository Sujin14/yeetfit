import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_list_item.dart';

class AdminListScreen extends ConsumerWidget {
  const AdminListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminState = ref.watch(adminControllerProvider);
    final controller = ref.watch(adminControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/user-dashboard'),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.colors['primaryAccent'],
          ),
        ),
        title: Text(
          'Select Admin',
          style: AppTheme.textStyles['title']?.copyWith(
            fontSize: FixedSizes.font18(context),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: adminState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : adminState.error != null
              ? Center(
                  child: Text(
                    adminState.error!,
                    style: AppTheme.textStyles['body']?.copyWith(
                      color: AppTheme.colors['error'],
                      fontSize: FixedSizes.font16(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : adminState.admins.isEmpty
                  ? Center(
                      child: Text(
                        'No admins available',
                        style: AppTheme.textStyles['bodyLarge']?.copyWith(
                          color: AppTheme.colors['secondaryText'],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(FixedSizes.box16(context)),
                      itemCount: adminState.admins.length,
                      itemBuilder: (context, index) {
                        final admin = adminState.admins[index];
                        return AdminListItem(admin: admin, controller: controller);
                      },
                    ),
    );
  }
}
