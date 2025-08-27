import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
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
          SizedBox(height: FixedSizes.box16(context)),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(
                color: AppTheme.colors['primaryText']?.withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(FixedSizes.radius12(context)),
              ),
            ),
            style: TextStyle(
              color: AppTheme.colors['primaryText']?.withOpacity(0.7),
              fontSize: FixedSizes.font16(context),
            ),
            validator: PaymentValidators.validateName,
          ),
          SizedBox(height: FixedSizes.box12(context)),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: AppTheme.colors['primaryText']?.withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(FixedSizes.radius12(context)),
              ),
            ),
            style: TextStyle(
              color: AppTheme.colors['primaryText']?.withOpacity(0.7),
              fontSize: FixedSizes.font16(context),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: PaymentValidators.validateEmail,
          ),
          SizedBox(height: FixedSizes.box12(context)),
          TextFormField(
            controller: contactController,
            decoration: InputDecoration(
              labelText: 'Contact Number',
              labelStyle: TextStyle(
                color: AppTheme.colors['primaryText']?.withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(FixedSizes.radius12(context)),
              ),
            ),
            style: TextStyle(
              color: AppTheme.colors['primaryText']?.withOpacity(0.7),
              fontSize: FixedSizes.font16(context),
            ),
            keyboardType: TextInputType.phone,
            validator: PaymentValidators.validateContact,
          ),
          SizedBox(height: FixedSizes.box24(context)),
          ElevatedButton(
            onPressed: isLoading ? null : onPayPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.blue,
              padding: EdgeInsets.symmetric(
                horizontal: FixedSizes.box32(context),
                vertical: FixedSizes.box16(context),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FixedSizes.radius16(context)),
              ),
            ),
            child: Text(
              isLoading ? 'Processing...' : 'Pay Now',
              style: AppTheme.textStyles['title']?.copyWith(
                color: AppTheme.colors['primaryText']?.withOpacity(0.7),
                fontSize: FixedSizes.font16(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
