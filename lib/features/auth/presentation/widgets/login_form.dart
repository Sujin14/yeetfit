import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/shared/widgets/shimmer_widget.dart';
import '../providers/email_auth_controller.dart';
import '../../domain/validators/auth_validators.dart';
import 'forgot_password_button.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(emailAuthControllerProvider.notifier);
      final success = await controller.login(
        emailController.text.trim(),
        passwordController.text.trim(),
        context,
      );

      if (success) {
        context.go('/user-dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not found, please create an account"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(emailAuthControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: AuthValidators.validateEmail,
          ),
          SizedBox(height: kIsWeb ? 20.h : 16.h),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: AuthValidators.validatePassword,
          ),
          SizedBox(height: kIsWeb ? 12.h : 8.h),
          const Align(
            alignment: Alignment.centerRight,
            child: ForgotPasswordButton(),
          ),
          SizedBox(height: kIsWeb ? 32.h : 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _login,
              child: isLoading
                  ? ShimmerLoading(
                      width: 100.w,
                      height: 20.h,
                    )
                  : const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}