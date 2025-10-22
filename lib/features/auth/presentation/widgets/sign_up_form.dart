import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/shimmer_widget.dart';
import '../providers/auth_providers.dart';
import '../validators/auth_validators.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/auth_strings.dart';
import '../../utils/widget_styles.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final result = await ref
          .read(signUpControllerProvider.notifier)
          .signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      handleAuthResult(context, result, AuthStrings.signupFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signUpControllerProvider);
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
                padding: WidgetStyles.buttonPadding(kIsWeb),
                shape: RoundedRectangleBorder(
                  borderRadius: WidgetStyles.buttonBorderRadius(),
                ),
                elevation: 0,
                shadowColor: AppTheme.colors['transparent'],
              ),
              child: isLoading
                  ? ShimmerLoading.text(
                      key: UniqueKey(),
                      text: 'Sign Up',
                      textStyle: WidgetStyles.buttonTextStyle(),
                    )
                  : Text(
                      "Sign Up",
                      style: WidgetStyles.buttonTextStyle(),
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