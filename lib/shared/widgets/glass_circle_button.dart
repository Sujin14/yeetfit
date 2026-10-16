import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Round frosted-glass icon button. Holding it repeats [onPressed], which
/// makes stepping through large numeric ranges practical.
class GlassCircleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final String? tooltip;

  const GlassCircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.tooltip,
  });

  @override
  State<GlassCircleButton> createState() => _GlassCircleButtonState();
}

class _GlassCircleButtonState extends State<GlassCircleButton> {
  static const _repeatInterval = Duration(milliseconds: 90);
  Timer? _repeatTimer;

  void _startRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = Timer.periodic(_repeatInterval, (_) {
      final onPressed = widget.onPressed;
      if (onPressed == null) {
        _stopRepeating();
      } else {
        onPressed();
      }
    });
  }

  void _stopRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  @override
  void didUpdateWidget(GlassCircleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onPressed == null) _stopRepeating();
  }

  @override
  void dispose() {
    _stopRepeating();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final enabled = widget.onPressed != null;

    final button = GestureDetector(
      onLongPressStart: enabled ? (_) => _startRepeating() : null,
      onLongPressEnd: (_) => _stopRepeating(),
      onLongPressCancel: _stopRepeating,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: widget.onPressed,
              customBorder: const CircleBorder(),
              child: Ink(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  widget.icon,
                  size: widget.size * 0.5,
                  color: enabled ? colors.onBackground : colors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return widget.tooltip == null
        ? button
        : Tooltip(message: widget.tooltip, child: button);
  }
}
