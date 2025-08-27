import 'package:flutter/material.dart';
import 'package:yeetfit/features/track_options/presentation/widgets/add_modal_widget.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

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
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FixedSizes.radius24(context)),
          ),
        ),
        child: const AddModalWidget(),
      ),
    );
  }
}
