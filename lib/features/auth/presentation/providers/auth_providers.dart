import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/email_auth_service.dart';
import '../../data/datasources/google_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_controller.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    emailService: EmailAuthService(),
    googleService: GoogleAuthService(),
  );
});

// Separate instances so each button shows only its own loading state.
final loginControllerProvider = NotifierProvider<AuthController, bool>(
  AuthController.new,
);

final signUpControllerProvider = NotifierProvider<AuthController, bool>(
  AuthController.new,
);

final resetPasswordControllerProvider = NotifierProvider<AuthController, bool>(
  AuthController.new,
);

final googleAuthControllerProvider = NotifierProvider<AuthController, bool>(
  AuthController.new,
);
