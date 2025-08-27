import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../controllers/payment_controller.dart';
import '../providers/payment_provider.dart';
import '../widgets/payment_form.dart';
import '../widgets/payment_header.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(paymentControllerProvider.notifier);
    final state = ref.watch(paymentControllerProvider);

    ref.listen<PaymentState>(paymentControllerProvider, (previous, next) {
      if (next.success) {
        context.go('/admin-list');
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'] ?? Colors.grey[900],
      appBar: AppBar(
        leading: InkWell(
          onTap: () => context.go('/user-dashboard'),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text('Unlock Chat Feature', style: AppTheme.textStyles['title']),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: GlassmorphicContainer(
              color: AppTheme.colors['primaryAccent'] ?? Colors.blue,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PaymentHeader(),
                  PaymentForm(
                    nameController: controller.nameController,
                    emailController: controller.emailController,
                    contactController: controller.contactController,
                    formKey: controller.formKey,
                    onPayPressed: controller.startPayment,
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
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
            ),
          if (state.success)
            Center(
              child: Text(
                'Payment Successful!',
                style: TextStyle(color: Colors.green, fontSize: 20.sp),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}