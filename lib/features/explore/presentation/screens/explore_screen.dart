import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _navBarVisible = true;
  int _currentIndex = 1;

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore',
          style: AppTheme.textStyles['title']!.copyWith(fontSize: 20.sp),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Explore Content Coming Soon!',
          style: AppTheme.textStyles['body']!.copyWith(fontSize: 18.sp),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        isVisible: _navBarVisible,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }
}
