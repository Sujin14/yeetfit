import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/dashboard_provider.dart';

class ProgressCard extends ConsumerWidget {
  final String title;
  final double percent;
  final String value;
  final IconData icon;
  final String description;
  final String? route;
  final String userId;
  final bool isLoading;

  const ProgressCard({
    super.key,
    required this.title,
    required this.percent,
    required this.value,
    required this.icon,
    required this.description,
    required this.route,
    required this.userId,
    this.isLoading = false,
  });

  const ProgressCard.loading({
    super.key,
    this.title = '',
    this.percent = 0.0,
    this.value = '',
    this.icon = Icons.help,
    this.description = '',
    this.route,
    required this.userId,
  }) : isLoading = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressColor = ref.watch(progressColorProvider(percent));

    return isLoading
        ? Shimmer.fromColors(
            baseColor: AppTheme.colors['secondaryText']!.withOpacity(0.2),
            highlightColor: AppTheme.colors['secondaryText']!.withOpacity(0.4),
            child: _buildCard(
              context,
              progressColor: AppTheme.colors['secondaryText']!,
            ),
          )
        : GestureDetector(
            onTap: route != null
                ? () => GoRouter.of(context).push(route!, extra: userId)
                : null,
            child: _buildCard(context, progressColor: progressColor),
          );
  }

  Widget _buildCard(BuildContext context, {required Color progressColor}) {
    return GlassmorphicContainer(
      width: FixedSizes.box100(context) * 3.6, // ~360.w
      height: FixedSizes.box100(context) * 2.0, // ~200.h
      borderRadius: FixedSizes.borderRadius(context) / 1.5,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.colors['navigationAccent']!.withOpacity(0.1),
          AppTheme.colors['navigationAccent']!.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['gradientTextStart']!,
          AppTheme.colors['gradientTextEnd']!,
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: FixedSizes.box8(context)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(FixedSizes.box8(context)),
              child: isLoading
                  ? _buildShimmerIndicator(context)
                  : CircularPercentIndicator(
                      radius: FixedSizes.box50(context) * 1.0,
                      lineWidth: FixedSizes.box8(context),
                      percent: percent.clamp(0.0, 1.0),
                      center: Icon(
                        icon,
                        size: FixedSizes.font16(context) * 1.2,
                        color: AppTheme.colors['primaryText'],
                      ),
                      progressColor: progressColor,
                      backgroundColor: AppTheme.colors['secondaryText']!
                          .withOpacity(0.2),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: FixedSizes.box8(context),
                horizontal: FixedSizes.box8(context),
              ),
              child: isLoading
                  ? _buildShimmerContent(context)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.textStyles['subtitle']!.copyWith(
                            fontSize: FixedSizes.font14(context),
                            color: AppTheme.colors['primaryText'],
                          ),
                        ),
                        SizedBox(height: FixedSizes.box4(context)),
                        Text(
                          value,
                          style: AppTheme.textStyles['body']!.copyWith(
                            fontSize: FixedSizes.font12(context),
                            color: AppTheme.colors['secondaryText'],
                          ),
                        ),
                        SizedBox(height: FixedSizes.box4(context)),
                        Text(
                          description,
                          style: AppTheme.textStyles['body']!.copyWith(
                            fontSize: FixedSizes.font10(context),
                            color: AppTheme.colors['secondaryText']!
                                .withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerIndicator(BuildContext context) {
    return Container(
      width: FixedSizes.box100(context) * 0.9,
      height: FixedSizes.box100(context) * 0.9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.colors['white'],
      ),
    );
  }

  Widget _buildShimmerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: FixedSizes.box100(context),
          height: FixedSizes.box12(context),
          color: AppTheme.colors['white'],
        ),
        SizedBox(height: FixedSizes.box4(context)),
        Container(
          width: FixedSizes.box80(context),
          height: FixedSizes.box12(context),
          color: AppTheme.colors['white'],
        ),
        SizedBox(height: FixedSizes.box4(context)),
        Container(
          width: FixedSizes.box150(context),
          height: FixedSizes.box20(context),
          color: AppTheme.colors['white'],
        ),
      ],
    );
  }
}
