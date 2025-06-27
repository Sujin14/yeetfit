import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/user/user_info_collection/application/user_info_controller.dart';

class UserDashboard extends ConsumerWidget {
  const UserDashboard({super.key});

  void _logout(BuildContext context, WidgetRef ref) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final isGoogleUser = user.providerData.any(
          (info) => info.providerId == 'google.com',
        );
        if (isGoogleUser) {
          final googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
        }
        await FirebaseAuth.instance.signOut();
        ref.read(userInfoControllerProvider.notifier).reset();
        context.go('/welcome');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context, ref),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'User Dashboard Placeholder',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
