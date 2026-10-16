import 'package:flutter/material.dart';

/// Counts from 0 up to [value] once, when first mounted, and passes the
/// in-between value to [builder]. Later changes to [value] show immediately.
class CountUpBuilder extends StatefulWidget {
  final double value;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext context, double value) builder;

  const CountUpBuilder({
    super.key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
  });

  @override
  State<CountUpBuilder> createState() => _CountUpBuilderState();
}

class _CountUpBuilderState extends State<CountUpBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.isAnimating || _controller.isCompleted) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) =>
          widget.builder(context, widget.value * _progress.value),
    );
  }
}
