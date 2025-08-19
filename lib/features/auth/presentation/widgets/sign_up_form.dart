import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/shimmer_widget.dart';
import '../providers/email_auth_controller.dart';
import '../../domain/validators/auth_validators.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final success = await ref
          .read(emailAuthControllerProvider.notifier)
          .signUp(_email.trim(), _password.trim(), context);
      if (success) {
        context.go('/user-info-step/0');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed')),
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
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.validateEmail,
            onSaved: (val) => _email = val ?? '',
          ),
          SizedBox(height: kIsWeb ? 20.h : 16.h),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: AuthValidators.validatePassword,
            onSaved: (val) => _password = val ?? '',
          ),
          SizedBox(height: kIsWeb ? 32.h : 24.h),
          isLoading
              ? ShimmerLoading(
                  width: 100.w,
                  height: 20.h,
                )
              : ElevatedButton(
                  onPressed: () => _submit(context),
                  child: const Text("Sign Up"),
                ),
        ],
      ),
    );
  }
}