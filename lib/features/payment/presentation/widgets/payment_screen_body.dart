import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../providers/payment_provider.dart';
import '../widgets/payment_form.dart';
import '../widgets/payment_header.dart';

class PaymentScreenBody extends ConsumerWidget {
  const PaymentScreenBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(paymentControllerProvider.notifier);
    final state = ref.watch(paymentControllerProvider);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: GlassmorphicContainer(
            color: AppTheme.colors['primaryAccent']!,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PaymentHeader(),
                PaymentForm(
                  nameController: controller.nameController,
                  emailController: controller.emailController,
                  contactController: controller.contactController,
                  formKey: controller.formKey,
                  onPayPressed: () => controller.startPayment(context),
                  isLoading: state.isLoading,
                ),
              ],
            ),
          ),
        ),
        if (state.isLoading) const Center(child: CircularProgressIndicator()),
        if (state.error != null)
          Center(
            child: Text(
              state.error!,
              style: AppTheme.textStyles['bodyMedium']!.copyWith(
                color: AppTheme.colors['error'],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        if (state.success)
          Center(
            child: Text(
              'Payment Successful!',
              style: AppTheme.textStyles['title']!.copyWith(
                color: AppTheme.colors['fullProgress'],
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}