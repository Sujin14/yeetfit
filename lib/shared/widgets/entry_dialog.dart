import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void entryDialog({
  required BuildContext context,
  required WidgetRef ref,
  required Widget dialog,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Entry Dialog',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: dialog,
        ),
      );
    },
  );
}
