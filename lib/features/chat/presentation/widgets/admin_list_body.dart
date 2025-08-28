import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_list_item.dart';

class AdminListBody extends ConsumerWidget {
  const AdminListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminState = ref.watch(adminControllerProvider);
    final controller = ref.watch(adminControllerProvider.notifier);

    return SafeArea(
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              onPressed: () => controller.navigateBack(context),
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.colors['primaryAccent']),
            ),
            title: Text('Select Admin', style: AppTheme.textStyles['title']),
          ),
          Expanded(
            child: adminState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : adminState.error != null
                    ? Center(
                        child: Text(
                          adminState.error!,
                          style: AppTheme.textStyles['bodyMedium']?.copyWith(
                            color: AppTheme.colors['error'],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : adminState.admins.isEmpty
                        ? Center(
                            child: Text(
                              'No admins available',
                              style: AppTheme.textStyles['bodyMedium']?.copyWith(
                                color: AppTheme.colors['secondaryText'],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16.w),
                            itemCount: adminState.admins.length,
                            itemBuilder: (context, index) {
                              final admin = adminState.admins[index];
                              return AdminListItem(admin: admin, onTap: () => controller.selectAdmin(context, admin.id));
                            },
                          ),
          ),
        ],
      ),
    );
  }
}