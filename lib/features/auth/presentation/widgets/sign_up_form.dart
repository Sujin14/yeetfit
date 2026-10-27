import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/user_info/domain/validators/user_info_validators.dart';
import 'package:yeetfit/features/user_info/presentation/providers/user_info_provider.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../providers/auth_providers.dart';
import '../validators/auth_validators.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/auth_strings.dart';
import 'google_button.dart';
import 'sign_up_legal_consent.dart';
import 'login_options_divider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToLegal = false;

  Future<void> _signUp() async {
    if (!_agreedToLegal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the Terms & Conditions and Privacy Policy',
          ),
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(signUpControllerProvider.notifier)
        .signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
    if (!mounted) return;
    if (result.success) {
      // Sign-up only creates the auth account; the name is persisted by the
      // user-info flow, whose first step pre-fills from this pending value.
      ref
          .read(userInfoControllerProvider.notifier)
          .setFormValue('name', _nameController.text.trim());
    }
    handleAuthResult(context, result, AuthStrings.signupFailed);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signUpControllerProvider);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            YeetTextField(
              controller: _nameController,
              hintText: 'Name',
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              validator: UserInfoValidators.validateName,
              onPhoto: true,
            ),
            const SizedBox(height: AppSpacing.md),
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
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: AuthValidators.validatePassword,
              onPhoto: true,
            ),
            const SizedBox(height: AppSpacing.md),
            YeetTextField(
              controller: _confirmController,
              hintText: 'Confirm password',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirm,
              suffixIcon: _obscureConfirm
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              suffixTooltip: _obscureConfirm
                  ? 'Show password'
                  : 'Hide password',
              onSuffixTap: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => isLoading ? null : _signUp(),
              validator: (value) => AuthValidators.confirmPassword(
                value,
                _passwordController.text,
              ),
              onPhoto: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            SignUpLegalConsent(
              onChanged: (agreed) => setState(() => _agreedToLegal = agreed),
            ),
            const SizedBox(height: AppSpacing.md),
            GradientButton(
              label: 'Create account',
              isLoading: isLoading,
              onPressed: _agreedToLegal ? _signUp : null,
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
