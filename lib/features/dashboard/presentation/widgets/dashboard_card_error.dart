import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';

/// Glass card for a dashboard section that failed to load.
class DashboardCardError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const DashboardCardError({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      padding: EdgeInsets.zero,
      child: YeetErrorState.compact(message: message, onRetry: onRetry),
    );
  }
}
