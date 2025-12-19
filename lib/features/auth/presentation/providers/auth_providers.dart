import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/auth_service.dart';
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
import 'login_controller.dart';
import 'signup_controller.dart';
import 'reset_password_controller.dart';
import 'google_auth_controller.dart'; // New import

// Providers for data sources
final emailAuthServiceProvider = Provider<AuthService>((ref) => EmailAuthService());
final googleAuthServiceProvider = Provider<AuthService>((ref) => GoogleAuthService());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    emailService: ref.watch(emailAuthServiceProvider),
    googleService: ref.watch(googleAuthServiceProvider),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(userService: FirestoreUserService());
});

final loginControllerProvider = StateNotifierProvider<LoginController, bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  return LoginController(
    loginWithEmail: LoginWithEmail(repo),
    userRepository: userRepo,
  );
});

final signUpControllerProvider = StateNotifierProvider<SignUpController, bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  return SignUpController(
    signUpWithEmail: SignUpWithEmail(repo),
    userRepository: userRepo,
  );
});

final resetPasswordControllerProvider = StateNotifierProvider<ResetPasswordController, bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return ResetPasswordController(
    resetPasswordUseCase: SendPasswordResetEmail(repo),
  );
});

final googleAuthControllerProvider = StateNotifierProvider<GoogleAuthController, bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  return GoogleAuthController(
    loginWithGoogle: LoginWithGoogle(repo),
    userRepository: userRepo,
  );
});