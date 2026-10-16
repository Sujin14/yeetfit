import 'package:flutter/material.dart';
import '../../domain/entities/call_status.dart';
import '../providers/active_call_state.dart';
import 'call_duration_timer.dart';

/// One line under the other party's name: progress while connecting, then
/// the running call duration.
class CallStatusText extends StatelessWidget {
  final CallConnectionPhase phase;
  final CallStatus status;
  final bool isCaller;
  final String otherPartyName;
  final DateTime? startedAt;
  final String? error;
  final TextStyle? style;

  const CallStatusText({
    super.key,
    required this.phase,
    required this.status,
    required this.isCaller,
    required this.otherPartyName,
    required this.startedAt,
    this.error,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final startedAt = this.startedAt;
    if (phase == CallConnectionPhase.connected && startedAt != null) {
      return CallDurationTimer(startedAt: startedAt, style: style);
    }
    final label = switch (phase) {
      CallConnectionPhase.failed => error ?? 'Call failed',
      CallConnectionPhase.reconnecting => 'Reconnecting…',
      CallConnectionPhase.connecting => 'Connecting…',
      CallConnectionPhase.connected => 'Connected',
      CallConnectionPhase.waiting =>
        status == CallStatus.ringing && isCaller
            ? 'Ringing…'
            : 'Waiting for $otherPartyName…',
    };
    return Text(label, textAlign: TextAlign.center, style: style);
  }
}
