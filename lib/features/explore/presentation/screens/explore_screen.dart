import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../widgets/plan_list_display.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: FixedSizes.box16(context),
            vertical: FixedSizes.box16(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: FixedSizes.box16(context)),
              Text(
                'Your Plans',
                style: AppTheme.textStyles['heading']?.copyWith(
                      color: AppTheme.colors['primaryText'] ?? Colors.black,
                      fontSize: FixedSizes.font24(context),
                    ) ??
                    TextStyle(
                      fontSize: FixedSizes.font24(context),
                      color: Colors.black,
                    ),
              ),
              SizedBox(height: FixedSizes.box16(context)),
              const Expanded(child: PlanListDisplay()),
            ],
          ),
        ),
      ),
    );
  }
}
