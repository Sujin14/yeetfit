import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/widget_styles.dart';
import '../../../../core/routes/auth_route_constants.dart';

class SignInRedirect extends StatelessWidget {
  const SignInRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AuthRouteConstants.root),
      child: Text(
        "Already have an account? Sign in",
        style: WidgetStyles.linkTextStyle(kIsWeb),
      ),
    );
  }
}
