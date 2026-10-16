import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../providers/auth_providers.dart';
import '../validators/auth_validators.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/auth_strings.dart';
import 'forgot_password_button.dart';
import 'google_button.dart';
import 'login_options_divider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(loginControllerProvider.notifier)
        .loginWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
    if (!mounted) return;
    handleAuthResult(context, result, AuthStrings.loginFailed);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginControllerProvider);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            YeetTextField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: AuthValidators.validateEmail,
              onPhoto: true,
            ),
            const SizedBox(height: AppSpacing.md),
            YeetTextField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              suffixTooltip: _obscurePassword
                  ? 'Show password'
                  : 'Hide password',
              onSuffixTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => isLoading ? null : _login(),
              validator: AuthValidators.validatePassword,
              onPhoto: true,
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: ForgotPasswordButton(),
            ),
            const SizedBox(height: AppSpacing.sm),
            GradientButton(
              label: 'Sign in',
              isLoading: isLoading,
              onPressed: _login,
            ),
            const SizedBox(height: AppSpacing.md),
            const LoginOptionsDivider(),
            const SizedBox(height: AppSpacing.md),
            const GoogleButton(),
          ],
        ),
      ),
    );
  }
}
