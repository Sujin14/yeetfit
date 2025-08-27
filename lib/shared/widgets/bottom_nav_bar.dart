import 'package:flutter/material.dart';
import '../../features/track_options/presentation/screens/track_option_modal.dart';
import '../../utils/fixed_sizes.dart';
import '../theme/theme.dart';
import '../ui/bottom_nav_bar_ui.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final bool isVisible;
  final ValueChanged<int>? onIndexChanged;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.isVisible = true,
    this.onIndexChanged,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(BuildContext context, int index) {
    if (index == 2) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppTheme.colors['transparent'],
        barrierColor: AppTheme.colors['transparent'],
        builder: (context) => const TrackOptionsModal(),
      );
    } else {
      widget.onIndexChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return BottomNavBarUI(
      currentIndex: widget.currentIndex,
      children: [
        _buildNavItem(context, Icons.home, 0),
        _buildNavItem(context, Icons.explore, 1),
        _buildNavItem(context, Icons.add_circle, 2, isProminent: true),
        _buildNavItem(context, Icons.bar_chart, 3),
        _buildNavItem(context, Icons.favorite, 4),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    int index, {
    bool isProminent = false,
  }) {
    final isSelected = widget.currentIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(FixedSizes.box40(context)),
        onTap: () => _onItemTapped(context, index),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: FixedSizes.box8(context)),
          child: Center(
            child: Icon(
              icon,
              size: isProminent
                  ? FixedSizes.box32(context)
                  : FixedSizes.box28(context),
              color: isSelected
                  ? AppTheme.colors['navBarActive']!
                  : AppTheme.colors['navBarInactiveOpacity']!,
            ),
          ),
        ),
      ),
    );
  }
}
