import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/shared/widgets/shimmer_widget.dart';
import '../../../../core/routes/auth_route_constants.dart';
import '../../../../core/routes/shell_route_constants.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';
import '../../domain/entities/auth_result.dart';
import '../providers/auth_providers.dart';
import '../validators/auth_validators.dart';
import '../../../../shared/theme/theme.dart';

// Form widget for email sign up.
class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Handles sign up submission.
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final result = await ref
          .read(emailAuthControllerProvider.notifier)
          .signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      _handleAuthResult(result);
    }
  }

  // Handles post-auth result.
  void _handleAuthResult(AuthResult result) {
    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'Signup failed')),
      );
      return;
    }

    final exists = result.userExists;
    if (exists == true) {
      context.go(ShellRouteConstants.dashboard);
    } else {
      context.go(AuthRouteConstants.userInfoStep.replaceAll(':step', '0'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(emailAuthControllerProvider);
    final maxButtonWidth = kIsWeb ? 300.w : 250.w;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            controller: _emailController,
            labelText: 'example@gmail.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: AuthValidators.validateEmail,
            prefixIcon: Icons.email_outlined,
          ),
          SizedBox(height: 16.h),
          CustomTextFormField(
            controller: _passwordController,
            labelText: 'Password',
            textInputAction: TextInputAction.next,
            validator: AuthValidators.validatePassword,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
          ),
          SizedBox(height: 16.h),
          CustomTextFormField(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            textInputAction: TextInputAction.done,
            validator: (value) => AuthValidators.confirmPassword(
              value,
              _passwordController.text,
            ),
            isPassword: true,
            prefixIcon: Icons.lock_outline,
          ),
          SizedBox(height: 24.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxButtonWidth),
            child: ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
                shadowColor: AppTheme.colors['transparent'],
              ),
              child: isLoading
                  ? ShimmerLoading.text(
                      key: UniqueKey(),
                      text: 'Sign Up',
                      textStyle: AppTheme.textStyles['body']!.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colors['primaryText'],
                      ),
                    )
                  : const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}