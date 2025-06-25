/*import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/controllers/phone_auth_controller.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  bool isOtpSent = false;

  void sendOtp() {
    final input = phoneController.text.trim();

    if (input.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(input)) {
      _showError("Enter a valid 10-digit phone number");
      return;
    }

    final fullPhone = '+91$input';

    ref
        .read(phoneAuthControllerProvider.notifier)
        .login(fullPhone, context)
        .then((_) {
          setState(() => isOtpSent = true);
        });
  }

  void verifyOtp() {
    final otp = otpController.text.trim();
    if (otp.length != 6) {
      _showError("Enter a valid 6-digit OTP");
      return;
    }

    ref.read(phoneAuthControllerProvider.notifier).verifyOtp(otp, context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(phoneAuthControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Phone Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
  controller: phoneController,
  keyboardType: TextInputType.number,
  maxLength: 10,
  decoration: const InputDecoration(
    labelText: "Phone Number",
    prefixText: "+91 ",
    counterText: "",
  ),
),

            const SizedBox(height: 20),
            if (!isOtpSent)
              ElevatedButton(
                onPressed: isLoading ? null : sendOtp,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Get OTP"),
              ),
            if (isOtpSent) ...[
              const SizedBox(height: 24),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Enter OTP"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : verifyOtp,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Verify & Login"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
*/
