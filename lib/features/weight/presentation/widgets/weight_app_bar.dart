import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'weight_goal_dialog.dart';

class WeightAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const WeightAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    print('WeightAppBar: userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Weight Tracker',
        style: GoogleFonts.roboto(
          fontSize: 26.sp,
          color: AppTheme.colors['onSurface'],
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.edit,
            color: AppTheme.colors['onSurface'],
            size: 20.sp,
          ),
          onPressed: userId != null
              ? () {
                  print('WeightAppBar: Opening WeightGoalDialog for userId=$userId');
                  showDialog(
                    context: context,
                    builder: (context) => WeightGoalDialog(userId: userId),
                  );
                }
              : () {
                  print('WeightAppBar: Cannot open dialog, no authenticated user');
                },
          tooltip: 'Edit Goal',
        ),
      ],
    );
  }
}

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
