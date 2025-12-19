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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = _getIndexFromLocation(widget.navigationShell.currentIndex);
  }

  int _getIndexFromLocation(int branchIndex) {
    return branchIndex > 1 ? branchIndex + 1 : branchIndex;
  }

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index != 2) {
      final branchIndex = index > 2 ? index - 1 : index;
      widget.navigationShell.goBranch(branchIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = NavigationTab.values[_currentIndex];
    final showCalendar = currentTab == NavigationTab.dashboard;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildAppDrawer(context),
      appBar: CustomAppBar(
        title: currentTab.title,
        showCalendar: showCalendar,
        onCalendar: _showCalendarDialog,
        scaffoldKey: _scaffoldKey, // 👈 added this line
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

  Widget _buildAppDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? "User";
    final email = user?.email ?? "No email";
    final photoUrl = user?.photoURL;

    return Drawer(
      backgroundColor: Colors.grey[50],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Profile Section ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    backgroundImage: photoUrl != null
                        ? NetworkImage(photoUrl)
                        : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // --- Settings Items ---
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black87),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context.push(SettingsRouteConstants.root);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black87),
              title: const Text('Account'),
              onTap: () {
                Navigator.pop(context);
                context.push('/account');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.black87),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                context.push('/help');
              },
            ),

            const Spacer(),

            // --- Logout Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) context.go('/login');
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

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
