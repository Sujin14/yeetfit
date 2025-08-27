import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yeetfit/features/track_options/presentation/widgets/add_modal_widget.dart';

import '../../../../shared/theme/theme.dart';

class TrackOptionsModal extends StatelessWidget {
  const TrackOptionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppTheme.colors['navigationAccent'],
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: const AddModalWidget(),
      ),
    );
  }
}
