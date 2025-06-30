import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../user_info/data/repositories/user_repository.dart';
import '../../data/datasources/email_auth_service.dart';
import '../../data/datasources/google_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../user_info/data/repositories/user_repository_impl.dart';
import '../../../user_info/data/datasources/firestore_user_service.dart';
import '../../domain/usecases/login_with_google.dart';

final googleAuthControllerProvider =
    StateNotifierProvider<GoogleAuthController, bool>((ref) {
      final repo = AuthRepositoryImpl(
        emailService: EmailAuthService(),
        googleService: GoogleAuthService(),
      );
      final userRepo = UserRepositoryImpl(userService: FirestoreUserService());
      return GoogleAuthController(
        loginWithGoogle: LoginWithGoogle(repo),
        userRepository: userRepo,
        ref: ref,
      );
    });

class GoogleAuthController extends StateNotifier<bool> {
  final LoginWithGoogle loginWithGoogle;
  final UserRepository userRepository;
  final Ref ref;

  GoogleAuthController({
    required this.loginWithGoogle,
    required this.userRepository,
    required this.ref,
  }) : super(false);

  Future<void> login(BuildContext context) async {
    state = true;
    final success = await loginWithGoogle();
    state = false;

    if (success) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final exists = await userRepository.checkUserExists(uid);
      if (exists) {
        context.go('/user-dashboard');
      } else {
        context.go('/user-info-step/0');
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Google Sign-In failed')));
    }
  }
}
