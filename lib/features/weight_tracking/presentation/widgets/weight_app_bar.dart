import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeightAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const WeightAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    print(
      'WeightAppBar: userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}',
    );
    return AppBar(
      elevation: 2,
      leading: IconButton(
        onPressed: () => context.go('/user-dashboard'),
        icon: Icon(Icons.arrow_back_ios_new_rounded),
      ),
      centerTitle: true,
      title: Text(
        'Weight Tracker',
        style: GoogleFonts.roboto(
          fontSize: 26.sp,
          color: AppTheme.colors['onSurface'],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
