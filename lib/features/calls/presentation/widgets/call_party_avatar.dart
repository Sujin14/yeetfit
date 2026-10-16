import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// The other party's photo (or initial), optionally with an expanding ring
/// while the call is ringing.
class CallPartyAvatar extends StatefulWidget {
  final String name;
  final String photoUrl;
  final double radius;
  final bool pulsing;

  const CallPartyAvatar({
    super.key,
    required this.name,
    required this.photoUrl,
    this.radius = 56,
    this.pulsing = false,
  });

  @override
  State<CallPartyAvatar> createState() => _CallPartyAvatarState();
}

class _CallPartyAvatarState extends State<CallPartyAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    if (widget.pulsing) _pulse.repeat();
  }

  @override
  void didUpdateWidget(CallPartyAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing && !_pulse.isAnimating) {
      _pulse.repeat();
    } else if (!widget.pulsing && _pulse.isAnimating) {
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final radius = widget.radius;
    final initial = widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?';

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: colors.primary.withValues(alpha: 0.3),
      foregroundImage: widget.photoUrl.isNotEmpty
          ? CachedNetworkImageProvider(widget.photoUrl)
          : null,
      child: Text(
        initial,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: colors.onBackground,
          fontSize: radius * 0.8,
        ),
      ),
    );

    return SizedBox.square(
      dimension: radius * 3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.pulsing)
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                final t = _pulse.value;
                return Container(
                  width: radius * 2 * (1 + 0.5 * t),
                  height: radius * 2 * (1 + 0.5 * t),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withValues(alpha: 0.35 * (1 - t)),
                  ),
                );
              },
            ),
          avatar,
        ],
      ),
    );
  }
}
