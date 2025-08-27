import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../widgets/account_body.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => context.go('/settings'),
        ),
      ),
      body: AccountBody(),
    );
  }
}