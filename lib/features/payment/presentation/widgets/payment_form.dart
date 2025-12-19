import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../domain/validators/payment_validators.dart';

class PaymentForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController contactController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onPayPressed;
  final bool isLoading;

  const PaymentForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.contactController,
    required this.formKey,
    required this.onPayPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: AppTheme.colors['']),
              border: const OutlineInputBorder(),
            ),
            style: TextStyle(
              color: AppTheme.colors['primaryText']!.withOpacity(0.7),
            ),
            validator: PaymentValidators.validateName,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: AppTheme.colors['primaryText']!.withOpacity(0.7),
              ),
              border: const OutlineInputBorder(),
            ),
            style: TextStyle(
              color: AppTheme.colors['primaryText']!.withOpacity(0.7),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: PaymentValidators.validateEmail,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: contactController,
            decoration: InputDecoration(
              labelText: 'Contact Number',
              labelStyle: TextStyle(
                color: AppTheme.colors['primaryText']!.withOpacity(0.7),
              ),
              border: const OutlineInputBorder(),
            ),
            style: TextStyle(
              color: AppTheme.colors['primaryText']!.withOpacity(0.7),
            ),
            keyboardType: TextInputType.phone,
            validator: PaymentValidators.validateContact,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: isLoading ? null : onPayPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['primaryAccent'] ?? Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            child: Text(
              isLoading ? 'Processing...' : 'Pay Now',
              style: AppTheme.textStyles['title']!.copyWith(
                color: AppTheme.colors['primaryText']!.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
