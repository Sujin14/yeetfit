import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/providers/user_role_provider.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../../domain/entities/new_training_session.dart';
import '../providers/session_provider.dart';
import '../widgets/create_session_form.dart';

class CreateSessionScreen extends ConsumerWidget {
  const CreateSessionScreen({super.key});

  Future<void> _submit(
    BuildContext context,
    WidgetRef ref,
    NewTrainingSession session,
  ) async {
    final created = await ref
        .read(createSessionControllerProvider.notifier)
        .submit(session);
    if (!created || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session scheduled — members have been notified.'),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider).value ?? false;
    final isSubmitting = ref.watch(createSessionControllerProvider).isLoading;

    ref.listen(createSessionControllerProvider, (_, next) {
      if (!next.hasError || next.isLoading) return;
      final colors = Theme.of(context).extension<AppColors>()!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Couldn't schedule the session. Please try again.",
          ),
          backgroundColor: colors.error,
        ),
      );
    });

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            const GlassSliverAppBar(title: 'Schedule Session'),
            SliverToBoxAdapter(
              child: isAdmin
                  ? CreateSessionForm(
                      isSubmitting: isSubmitting,
                      onSubmit: (session) => _submit(context, ref, session),
                    )
                  : const SignInRequiredView(
                      message: 'Only coaches can schedule sessions.',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
