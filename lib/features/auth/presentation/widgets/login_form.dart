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
import 'forgot_password_button.dart';
import '../../../../shared/theme/theme.dart';

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
      FocusScope.of(context).unfocus();
      final result = await ref.read(loginControllerProvider.notifier).login(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
      handleAuthResult(context, result, AuthStrings.loginFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginControllerProvider);
    final maxButtonWidth = kIsWeb ? 300.w : 250.w;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            controller: emailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: AuthValidators.validateEmail,
            prefixIcon: Icons.email_outlined,
          ),
          SizedBox(height: 16.h),
          CustomTextFormField(
            controller: passwordController,
            labelText: 'Password',
            textInputAction: TextInputAction.done,
            validator: AuthValidators.validatePassword,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
          ),
          SizedBox(height: 8.h),
          const Align(
            alignment: Alignment.centerRight,
            child: ForgotPasswordButton(),
          ),
          SizedBox(height: 24.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxButtonWidth),
            child: ElevatedButton(
              onPressed: isLoading ? null : _login,
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
                      text: 'Login',
                      textStyle: WidgetStyles.buttonTextStyle(),
                    )
                  : Text(
                      'Login',
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}