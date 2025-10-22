import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/email_auth_service.dart';
import '../../data/datasources/google_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/sign_up_with_email.dart';
import '../../../user_info/data/datasources/firestore_user_service.dart';
import '../../../user_info/data/repositories/user_repository_impl.dart';
import '../../../user_info/domain/repositories/user_repository.dart';
import 'email_auth_controller.dart';
import 'google_auth_controller.dart';

// Provider for the auth repository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    emailService: EmailAuthService(),
    googleService: GoogleAuthService(),
  );
});

// Provider for the user repository (for post-auth checks).
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(userService: FirestoreUserService());
});

// Provider for email auth controller state (loading).
final emailAuthControllerProvider =
    StateNotifierProvider<EmailAuthController, bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  return EmailAuthController(
    loginWithEmail: LoginWithEmail(repo),
    resetPasswordUseCase: SendPasswordResetEmail(repo),
    signUpWithEmail: SignUpWithEmail(repo),
    userRepository: userRepo,
  );
});

// Provider for Google auth controller state (loading).
final googleAuthControllerProvider =
    StateNotifierProvider<GoogleAuthController, bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  return GoogleAuthController(
    loginWithGoogle: LoginWithGoogle(repo),
    userRepository: userRepo,
  );
});