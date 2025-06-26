// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../data/datasources/email_auth_service.dart';
// import '../../data/datasources/google_auth_service.dart';
// import '../../data/datasources/phone_auth_service.dart';
// import '../../data/repositories/auth_repository_impl.dart';
// import '../../domain/usecases/login_with_phone.dart';
// import '../../domain/usecases/verify_otp.dart';

// final phoneAuthControllerProvider =
//     StateNotifierProvider<PhoneAuthController, bool>((ref) {
//       final repo = AuthRepositoryImpl(
//         emailService: EmailAuthService(),
//         googleService: GoogleAuthService(),
//         //phoneService: PhoneAuthService(),
//       );
//       return PhoneAuthController(
//         loginWithPhone: LoginWithPhone(repo),
//         verifyOTP: VerifyOTP(repo),
//       );
//     });

// class PhoneAuthController extends StateNotifier<bool> {
//   final LoginWithPhone loginWithPhone;
//   final VerifyOTP verifyOTP;

//   String? _verificationId;

//   PhoneAuthController({required this.loginWithPhone, required this.verifyOTP})
//     : super(false);

//   Future<void> login(String phone, BuildContext context) async {
//     state = true;
//     await loginWithPhone(
//       phone,
//       (verificationId) {
//         _verificationId = verificationId;
//       },
//       (error) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(error)));
//       },
//     );
//     state = false;
//   }

//   Future<void> verifyOtp(String otp, BuildContext context) async {
//     if (_verificationId == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("OTP not sent yet")));
//       return;
//     }

//     state = true;
//     final success = await verifyOTP(_verificationId!, otp);
//     state = false;

//     if (success) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Phone login successful")));
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
//     }
//   }
// }
