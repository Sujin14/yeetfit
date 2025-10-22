import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/widget_styles.dart';
import '../../../../core/routes/auth_route_constants.dart';

class SignupRedirect extends StatelessWidget {
  const SignupRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AuthRouteConstants.signup),
      child: Text(
        "Don't have an account? Sign up",
        style: WidgetStyles.linkTextStyle(kIsWeb),
      ),
    );
  }
}