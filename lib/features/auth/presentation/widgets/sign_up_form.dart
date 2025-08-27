// sign_up_form.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/shared/widgets/shimmer_widget.dart';
import '../providers/email_auth_controller.dart';
import '../../domain/validators/auth_validators.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

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

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
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

    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: FixedSizes.box20(context)),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppTheme.colors['primaryAccent'],
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.validateEmail,
          ),
          SizedBox(height: FixedSizes.box20(context)),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
              ),
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
            ),
            obscureText: _obscurePassword,
            validator: AuthValidators.validatePassword,
          ),
          SizedBox(height: FixedSizes.box20(context)),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              labelStyle: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
              ),
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
            ),
            obscureText: _obscureConfirmPassword,
            validator: (value) =>
                AuthValidators.confirmPassword(value, _passwordController.text),
          ),
          SizedBox(height: FixedSizes.box32(context)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: FixedSizes.authButtonWidth(context),
            ),
            child: isLoading
                ? ShimmerLoading(
                    width: FixedSizes.box100(context),
                    height: FixedSizes.box20(context),
                  )
                : ElevatedButton(
                    onPressed: () => _submit(context),
                    child: Text(
                      "Sign Up",
                      style: AppTheme.textStyles['body']!.copyWith(
                        fontSize: FixedSizes.fontBody(context),
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
