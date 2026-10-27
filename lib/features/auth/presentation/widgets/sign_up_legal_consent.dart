import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/constants/legal_constants.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/utils/url_utils.dart';

/// Checkbox gate for creating an account. The choice stays on this screen.
class SignUpLegalConsent extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const SignUpLegalConsent({super.key, required this.onChanged});

  @override
  State<SignUpLegalConsent> createState() => _SignUpLegalConsentState();
}

class _SignUpLegalConsentState extends State<SignUpLegalConsent> {
  bool _agreed = false;
  late final TapGestureRecognizer _termsRecognizer = TapGestureRecognizer()
    ..onTap = () => _open(kTermsUrl);
  late final TapGestureRecognizer _privacyRecognizer = TapGestureRecognizer()
    ..onTap = () => _open(kPrivacyUrl);

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  void _open(String url) {
    unawaited(_openUrl(url));
  }

  Future<void> _openUrl(String url) async {
    try {
      await launchUrlExternal(url);
    } catch (error) {
      debugPrint('Opening $url failed: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final linkStyle = TextStyle(
      color: colors.primary,
      decoration: TextDecoration.underline,
    );

    return Row(
      children: [
        Checkbox(
          value: _agreed,
          onChanged: (value) {
            final agreed = value ?? false;
            setState(() => _agreed = agreed);
            widget.onChanged(agreed);
          },
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurface,
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: linkStyle,
                  recognizer: _termsRecognizer,
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: linkStyle,
                  recognizer: _privacyRecognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
