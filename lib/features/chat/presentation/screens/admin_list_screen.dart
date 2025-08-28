import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/admin_list_body.dart';

class AdminListScreen extends ConsumerWidget {
  const AdminListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: AdminListBody(),
    );
  }
}