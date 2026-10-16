import 'dart:async';
import 'package:flutter/material.dart';

/// Elapsed time since [startedAt] as m:ss (h:mm:ss past an hour).
class CallDurationTimer extends StatefulWidget {
  final DateTime startedAt;
  final TextStyle? style;

  const CallDurationTimer({super.key, required this.startedAt, this.style});

  @override
  State<CallDurationTimer> createState() => _CallDurationTimerState();
}

class _CallDurationTimerState extends State<CallDurationTimer> {
  late final Timer _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  static String _format(Duration elapsed) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes.remainder(60);
    final seconds = twoDigits(elapsed.inSeconds.remainder(60));
    return hours > 0
        ? '$hours:${twoDigits(minutes)}:$seconds'
        : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = DateTime.now().difference(widget.startedAt);
    return Text(
      _format(elapsed.isNegative ? Duration.zero : elapsed),
      style: widget.style,
    );
  }
}
