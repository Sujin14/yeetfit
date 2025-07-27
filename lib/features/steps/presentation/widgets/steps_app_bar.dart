import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'steps_entry_dialog.dart';

class StepsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const StepsAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Step Counter',
        style: GoogleFonts.roboto(
          fontSize: 26.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: Colors.white, size: 24.sp),
          onPressed: userId != null
              ? () => showDialog(
                    context: context,
                    builder: (context) => StepsEntryDialog(userId: userId),
                  )
              : null,
          tooltip: 'Add Steps Entry',
        ),
      ],
    );
  }
}

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);