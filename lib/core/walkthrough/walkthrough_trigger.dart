import 'package:flutter/material.dart';
import 'walkthrough_controller.dart';
import 'yana_tour_intro_dialog.dart';

/// Starts a Yana tour once, the first time this widget mounts, unless the
/// account already finished or skipped it. Place it around content that only
/// builds once its data is ready, below the `ShowCaseWidget` hosting the
/// tour's targets.
class WalkthroughTrigger extends StatefulWidget {
  final String tourKey;
  final String userId;
  final List<GlobalKey> targets;

  /// Shown in Yana's intro dialog first; `null` starts the tour directly.
  final String? introMessage;
  final Widget child;

  const WalkthroughTrigger({
    super.key,
    required this.tourKey,
    required this.userId,
    required this.targets,
    this.introMessage,
    required this.child,
  });

  @override
  State<WalkthroughTrigger> createState() => _WalkthroughTriggerState();
}

class _WalkthroughTriggerState extends State<WalkthroughTrigger> {
  bool _walkthroughStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStart());
  }

  Future<void> _maybeStart() async {
    if (_walkthroughStarted) return;
    _walkthroughStarted = true;

    final shouldShow = await WalkthroughController.shouldShow(
      widget.tourKey,
      widget.userId,
    );
    if (!shouldShow || !mounted) return;

    final introMessage = widget.introMessage;
    if (introMessage != null) {
      final accepted = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.7),
        builder: (_) => YanaTourIntroDialog(
          title: "Hi! I'm Yana 👋",
          message: introMessage,
        ),
      );
      if (accepted != true) {
        await WalkthroughController.markDone(widget.tourKey, widget.userId);
        return;
      }
      if (!mounted) return;
    }

    WalkthroughController.start(
      context,
      key: widget.tourKey,
      uid: widget.userId,
      targets: widget.targets,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
