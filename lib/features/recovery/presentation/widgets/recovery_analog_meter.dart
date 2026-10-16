import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'recovery_meter_painter.dart';

/// Analog meter for a 0–100 recovery score. [width] and [height] are the
/// space it takes in the card; the dial fills that space. The needle sweeps
/// from 0 the first time the meter is shown, and from its current position
/// when [score] changes. Rebuilds that keep the same score leave it still.
class RecoveryAnalogMeter extends StatefulWidget {
  /// Layout slot. Growing this grows the dashboard card, so the dial is
  /// scaled inside it instead.
  static const double width = 136;
  static const double height = 104;

  final int score;

  const RecoveryAnalogMeter({super.key, required this.score});

  @override
  State<RecoveryAnalogMeter> createState() => _RecoveryAnalogMeterState();
}

class _RecoveryAnalogMeterState extends State<RecoveryAnalogMeter>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 900);

  late final AnimationController _controller;
  double _from = 0;
  late double _to;
  bool _sweepStarted = false;

  double get _needle {
    final t = Curves.easeOutCubic.transform(_controller.value);
    return _from + (_to - _from) * t;
  }

  @override
  void initState() {
    super.initState();
    _to = widget.score.clamp(0, 100).toDouble();
    _controller = AnimationController(vsync: this, duration: _duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // MediaQuery isn't available until after initState. Start the opening
    // sweep once; later calls must not replay it.
    if (_sweepStarted) return;
    _sweepStarted = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _from = _to;
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(RecoveryAnalogMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score == widget.score) return;

    _from = _needle;
    _to = widget.score.clamp(0, 100).toDouble();
    if (MediaQuery.disableAnimationsOf(context) || _from == _to) {
      _from = _to;
      _controller.value = 1;
      return;
    }
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final labelStyle = textTheme.bodySmall!.copyWith(fontSize: 10);

    return SizedBox(
      width: RecoveryAnalogMeter.width,
      height: RecoveryAnalogMeter.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
          painter: RecoveryMeterPainter(
            value: _needle,
            trackColor: Colors.white.withValues(alpha: 0.12),
            lowColor: colors.error,
            midColor: colors.warning,
            highColor: colors.success,
            needleColor: colors.onBackground,
            hubColor: colors.primary,
            tickColor: colors.onBackground.withValues(alpha: 0.55),
            labelColor: colors.textSecondary,
            labelStyle: labelStyle,
          ),
          child: child,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            '${widget.score}',
            style: textTheme.titleLarge!.copyWith(
              color: colors.onBackground,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}
