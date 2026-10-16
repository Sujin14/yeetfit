import 'package:flutter/material.dart';
import 'package:yeetfit/features/track_options/presentation/widgets/add_modal_widget.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class TrackOptionsModal extends StatelessWidget {
  const TrackOptionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(color: colors.secondary.withValues(alpha: 0.35)),
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const AddModalWidget(),
      ),
    );
  }
}
