import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/bmi_provider.dart';
import 'bmi_front_card.dart';
import 'bmi_back_card.dart';
import 'bmi_shimmer_card.dart';

class BMISuggestions extends ConsumerStatefulWidget {
  final AsyncValue<Map<String, dynamic>?> userData;
  final String userId;

  const BMISuggestions({
    super.key,
    required this.userData,
    required this.userId,
  });

  @override
  ConsumerState<BMISuggestions> createState() => _BMISuggestionsState();
}

class _BMISuggestionsState extends ConsumerState<BMISuggestions>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  void _toggleCard() {
    setState(() => _isFlipped = !_isFlipped);
    _isFlipped ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final bmiAsync = ref.watch(bmiStreamProvider(widget.userId));

    return bmiAsync.when(
      data: (bmi) {
        final bmiCategory = ref.read(bmiCategoryProvider(bmi));
        final bmiSuggestion = ref.read(bmiSuggestionProvider(bmi));

        Color bmiColor;
        if (bmi < 18.5) {
          bmiColor = colors.bmiUnderweight;
        } else if (bmi < 25) {
          bmiColor = colors.bmiNormal;
        } else if (bmi < 30) {
          bmiColor = colors.bmiOverweight;
        } else {
          bmiColor = colors.bmiObese;
        }

        return GestureDetector(
          onTap: _toggleCard,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final angle = _controller.value * pi;
              final isBackVisible = angle > pi / 2;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                child: isBackVisible
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(pi),
                        child: BMIBackCard(
                          bmi: bmi,
                          category: bmiCategory,
                          suggestion: bmiSuggestion,
                          bmiColor: bmiColor,
                        ),
                      )
                    : BMIFrontCard(userData: widget.userData),
              );
            },
          ),
        );
      },
      loading: () => BMIShimmerCard(),
      error: (e, _) => Container(
        height: 220.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: colors.error.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(child: Text('Error: $e')),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
