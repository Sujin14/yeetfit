import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../ui/bottom_nav_bar_ui.dart';
import 'add_modal.dart';
import '../theme/theme.dart';

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
    widget.onIndexChanged?.call(index);

    if (index == 2) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        builder: (context) => const AddModal(),
      ).then((_) {
        if (mounted) {
          widget.onIndexChanged?.call(widget.currentIndex);
        }
      });
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
        _buildNavItem(context, Icons.settings, 4),
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
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Icon(
          icon,
          size: isProminent ? 32.sp : 28.sp,
          color: isSelected
              ? AppTheme.colors['navBarActive']!
              : AppTheme.colors['navBarInactiveOpacity']!,
        ),
      ),
    );
  }
}
