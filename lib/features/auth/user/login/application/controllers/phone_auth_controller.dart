import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/email_auth_service.dart';
import '../../data/datasources/google_auth_service.dart';
import '../../data/datasources/phone_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_with_phone.dart';
import '../../domain/usecases/verify_otp.dart';

final phoneAuthControllerProvider =
    StateNotifierProvider<PhoneAuthController, bool>((ref) {
      final repo = AuthRepositoryImpl(
        emailService: EmailAuthService(),
        googleService: GoogleAuthService(),
        phoneService: PhoneAuthService(),
      );
      return PhoneAuthController(
        loginWithPhone: LoginWithPhone(repo),
        verifyOTP: VerifyOTP(repo),
      );
    });

class PhoneAuthController extends StateNotifier<bool> {
  final LoginWithPhone loginWithPhone;
  final VerifyOTP verifyOTP;

  PhoneAuthController({required this.loginWithPhone, required this.verifyOTP})
    : super(false);

  Future<void> login(String phone, BuildContext context) async {
    await loginWithPhone(
      phone,
      (verificationId) => _showOTPDialog(context, verificationId),
      (error) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error))),
    );
  }

  void _showOTPDialog(BuildContext context, String verificationId) {
    String otp = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter OTP"),
        content: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) => otp = value,
          decoration: const InputDecoration(hintText: "6-digit OTP"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await verifyOTP(verificationId, otp);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? "Phone login successful" : "Invalid OTP",
                  ),
                ),
              );
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }
}
