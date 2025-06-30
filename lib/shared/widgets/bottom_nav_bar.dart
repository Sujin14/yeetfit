import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../ui/bottom_nav_bar_ui.dart';
import 'add_modal.dart';

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
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(BottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      setState(() {
        _currentIndex = widget.currentIndex;
      });
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      _currentIndex = index;
    });

    widget.onIndexChanged?.call(index);

    if (index == 2) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const AddModal(),
      ).then((_) {
        if (mounted) {
          setState(() {
            _currentIndex = widget.currentIndex;
          });
        }
      });
    } else {
      final routes = [
        '/user-dashboard', // Home (index 0)
        '/explore', // Explore (index 1)
        '/progress', // Progress (index 3)
        '/settings', // Settings (index 4)
      ];
      context.go(routes[index > 2 ? index - 1 : index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return BottomNavBarUI(
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
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Icon(
          icon,
          size: isProminent ? 32.sp : 28.sp,
          color: isSelected ? Colors.teal : Colors.grey[600],
        ),
      ),
    );
  }
}
