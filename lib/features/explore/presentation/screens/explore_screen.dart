import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../widgets/plan_list_display.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Text(
                'Your Plans',
                style:
                    AppTheme.textStyles['heading']?.copyWith(
                      color: AppTheme.colors['primaryText'] ?? Colors.black,
                      fontSize: 24.sp,
                    ) ??
                    TextStyle(fontSize: 24.sp, color: Colors.black),
              ),
              SizedBox(height: 16.h),
              const Expanded(child: PlanListDisplay()),
            ],
          ),
        ),
      ),
    );
  }
}
