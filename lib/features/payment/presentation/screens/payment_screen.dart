import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../controllers/payment_controller.dart';
import '../widgets/payment_form.dart';
import '../widgets/payment_header.dart';
import '../widgets/web_view_widget.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(paymentControllerProvider.notifier);
    final state = ref.watch(paymentControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'] ?? Colors.grey[900],
      appBar: AppBar(
        leading: InkWell(
          onTap: () => context.go('/user-dashboard'),
          child: const Icon(Icons.arrow_back),
        ),
        title: Text('Unlock Chat Feature', style: AppTheme.textStyles['title']),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          if (state.paymentUrl != null)
            PaymentWebView(webViewController: state.webViewController!)
          else
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
        ],
      ),
    );
  }
}
