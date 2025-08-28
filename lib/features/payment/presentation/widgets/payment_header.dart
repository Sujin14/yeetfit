import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class PaymentHeader extends StatelessWidget {
  const PaymentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'One-Time Payment',
          style: AppTheme.textStyles['heading']!.copyWith(
            color: AppTheme.colors['primaryText']!.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Unlock the chat feature for a one-time payment of ₹500.',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['primaryText']!.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}