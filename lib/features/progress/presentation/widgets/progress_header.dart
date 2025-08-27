import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/progress_provider.dart';

class ProgressHeader extends ConsumerWidget {
  final ValueChanged<String?> onMetricChanged;
  const ProgressHeader({super.key, required this.onMetricChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final selected = ref.watch(selectedMetricProvider) ?? 'All Metrics';

    return Container(
      padding: EdgeInsets.all(isDesktop
          ? FixedSizes.box20(context)
          : FixedSizes.box16(context)),
      decoration: BoxDecoration(
        color: AppTheme.colors['indigo']!,
        borderRadius: BorderRadius.circular(FixedSizes.borderRadius(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Progress Heatmap',
            style: AppTheme.textStyles['title']!.copyWith(
              fontSize: FixedSizes.font20(context),
              color: AppTheme.colors['primaryText'],
            ),
          ),
          DropdownButton<String>(
            value: selected,
            dropdownColor: AppTheme.colors['indigo']!.withOpacity(0.5),
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['primaryText'],
              fontSize: isDesktop
                  ? FixedSizes.font16(context)
                  : FixedSizes.font14(context),
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: AppTheme.colors['primaryText'],
            ),
            underline: const SizedBox(),
            onChanged: (value) {
              final v = value == 'All Metrics' ? null : value;
              ref.read(selectedMetricProvider.notifier).state = v;
              onMetricChanged(value);
            },
            items: const [
              DropdownMenuItem(
                value: 'All Metrics',
                child: Text('All Metrics'),
              ),
              DropdownMenuItem(value: 'food', child: Text('Meal Tracking')),
              DropdownMenuItem(value: 'sleep', child: Text('Sleep')),
              DropdownMenuItem(value: 'steps', child: Text('Steps')),
              DropdownMenuItem(value: 'water', child: Text('Water')),
              DropdownMenuItem(value: 'weight', child: Text('Weight')),
            ],
          ),
        ],
      ),
    );
  }
}
