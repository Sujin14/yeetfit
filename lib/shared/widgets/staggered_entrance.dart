import 'package:flutter/material.dart';

/// Fades and slides [child] up into place once, when first mounted.
/// The [index]th item waits `index * stagger` before its [duration]-long
/// entrance, so a column of these cascades.
class StaggeredEntrance extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration stagger;
  final Duration duration;

  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
    this.stagger = const Duration(milliseconds: 80),
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    final delay = widget.stagger * widget.index;
    final total = delay + widget.duration;
    // One controller covers the delay too, so no timer needs cancelling.
    _controller = AnimationController(vsync: this, duration: total);
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        delay.inMicroseconds / total.inMicroseconds,
        1,
        curve: Curves.easeOutCubic,
      ),
    );
    _opacity = curve;
    _offset = Tween(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curve);
  }

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
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}
