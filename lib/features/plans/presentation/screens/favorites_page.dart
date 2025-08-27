import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../utils/fixed_sizes.dart';
import '../widgets/favorite_plan_display.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: FixedSizes.box16(context),
            vertical: FixedSizes.box16(context),
          ),
          child: const FavoritePlansDisplay(),
        ),
      ),
    );
  }
}
