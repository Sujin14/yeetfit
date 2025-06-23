import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/auth/presentation/services/phone_auth_service.dart';

final phoneAuthControllerProvider =
    StateNotifierProvider<PhoneAuthController, bool>(
      (ref) => PhoneAuthController(ref),
    );

class PhoneAuthController extends StateNotifier<bool> {
  final Ref ref;
  final PhoneAuthService _service = PhoneAuthService();

  PhoneAuthController(this.ref) : super(false);

  Future<void> phoneLogin(String phone, BuildContext context) async {
    await _service.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (verificationId) {
        _showOTPDialog(context, verificationId);
      },
      onFailed: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      },
    );
  }

  void _showOTPDialog(BuildContext context, String verificationId) {
    String otp = "";
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
              final result = await _service.signInWithOTP(
                verificationId: verificationId,
                smsCode: otp.trim(),
              );
              if (result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Phone login successful")),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
              }
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }
}
