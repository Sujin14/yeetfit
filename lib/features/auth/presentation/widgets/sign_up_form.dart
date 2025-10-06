import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/shared/widgets/shimmer_widget.dart';
import '../providers/email_auth_controller.dart';
import '../../domain/validators/auth_validators.dart';
import '../../../../shared/theme/theme.dart';

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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Dismiss keyboard
      final success = await ref
          .read(emailAuthControllerProvider.notifier)
          .signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            context,
          );
      if (success) {
        context.go('/user-info-step/0');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Signup failed')));
      }
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
          TextFormField(
            controller: _emailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'example@gmail.com',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppTheme.colors['primaryAccent'],
              ),
              labelStyle: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppTheme.colors['primaryAccent']!,
                  width: 2,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.validateEmail,
          ),
          SizedBox(height: 16.h),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppTheme.colors['primaryAccent'],
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.colors['primaryAccent'],
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              labelStyle: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppTheme.colors['primaryAccent']!,
                  width: 2,
                ),
              ),
            ),
            validator: AuthValidators.validatePassword,
          ),
          SizedBox(height: 16.h),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppTheme.colors['primaryAccent'],
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppTheme.colors['primaryAccent'],
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              labelStyle: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppTheme.colors['primaryAccent']!,
                  width: 2,
                ),
              ),
            ),
            validator: (value) =>
                AuthValidators.confirmPassword(value, _passwordController.text),
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
                  : Text(
                      "Sign Up",
                      style: AppTheme.textStyles['body']!.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colors['primaryText'],
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
