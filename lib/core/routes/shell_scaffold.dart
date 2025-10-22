import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/dashboard/presentation/widgets/calendar_dialog.dart';
import 'package:yeetfit/shared/widgets/custom_appbar.dart';
import 'package:yeetfit/shared/widgets/bottom_nav_bar.dart';
import 'navigation_enum.dart';
import 'settings_route_constants.dart';

/// Scaffold wrapper for main app shell with bottom navigation.
class ShellScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({super.key, required this.navigationShell});

  @override
  State<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<ShellScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = _getIndexFromLocation(widget.navigationShell.currentIndex);
  }

  /// Maps current location to navigation index.
  int _getIndexFromLocation(int branchIndex) {
    // Adjust for skipped 'track' tab (index 2).
    return branchIndex > 1 ? branchIndex + 1 : branchIndex;
  }

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index != 2) { // Skip 'track' (modals).
      // Map to branch: 0->0, 1->1, 3->2, 4->3.
      final branchIndex = index > 2 ? index - 1 : index;
      widget.navigationShell.goBranch(branchIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = NavigationTab.values[_currentIndex];
    final showCalendar = currentTab == NavigationTab.dashboard;

    return Scaffold(
      appBar: CustomAppBar(
        title: currentTab.title,
        showCalendar: showCalendar,
        onCalendar: _showCalendarDialog,
        showSettings: true,
        onSettings: () => context.push(SettingsRouteConstants.root),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widget.navigationShell,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        isVisible: true,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }

  // Shows calendar dialog for authenticated users.
  void _showCalendarDialog() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) => CalendarDialog(userId: user.uid),
      );
    }
  }
}