import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/shell_route_constants.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import '../../data/datasources/yana_intro_local_datasource.dart';
import '../widgets/yana_intro_body.dart';

/// One-time introduction to Yana, shown before the first dashboard visit.
class YanaIntroScreen extends ConsumerWidget {
  const YanaIntroScreen({super.key});

  // The flag is cached before the await, so the dashboard redirect already
  // sees it as shown.
  Future<void> _complete(BuildContext context, String? userId) async {
    if (userId != null) await YanaIntroLocalDataSource.markShown(userId);
    if (context.mounted) context.go(ShellRouteConstants.dashboard);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: YanaIntroBody(onComplete: () => _complete(context, userId)),
    );
  }
}
