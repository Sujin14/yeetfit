import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/payment_appbar.dart';
import '../widgets/payment_screen_body.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: PaymentAppBar(),
      body: PaymentScreenBody(),
    );
  }
}