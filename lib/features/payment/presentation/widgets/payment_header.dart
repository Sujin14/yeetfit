import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class PaymentHeader extends StatelessWidget {
  const PaymentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'One-Time Payment',
          style: AppTheme.textStyles['heading']?.copyWith(
            color: AppTheme.colors['primaryText']?.withOpacity(0.7),
            fontSize: FixedSizes.font24(context),
          ),
        ),
        SizedBox(height: FixedSizes.box16(context)),
        Text(
          'Unlock the chat feature for a one-time payment of ₹500.',
          style: AppTheme.textStyles['body']?.copyWith(
            color: AppTheme.colors['primaryText']?.withOpacity(0.7),
            fontSize: FixedSizes.font16(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
