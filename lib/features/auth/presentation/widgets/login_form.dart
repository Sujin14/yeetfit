// login_form.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/shared/widgets/shimmer_widget.dart';
import '../providers/email_auth_controller.dart';
import '../../domain/validators/auth_validators.dart';
import 'forgot_password_button.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

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
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppTheme.colors['primaryAccent'],
              ),
              labelStyle: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
              ),
            ),
            validator: AuthValidators.validateEmail,
          ),
          SizedBox(height: FixedSizes.box20(context)),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppTheme.colors['primaryAccent'],
              ),
              labelStyle: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['secondaryText'],
              ),
            ),
            validator: AuthValidators.validatePassword,
          ),
          SizedBox(height: FixedSizes.box12(context)),
          const Align(
            alignment: Alignment.centerRight,
            child: ForgotPasswordButton(),
          ),
          SizedBox(height: FixedSizes.box32(context)),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: FixedSizes.authButtonWidth(context)),
            child: ElevatedButton(
              onPressed: isLoading ? null : _login,
              child: isLoading
                  ? ShimmerLoading(
                      width: FixedSizes.box100(context),
                      height: FixedSizes.box20(context),
                    )
                  : Text(
                      'Login',
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
}
