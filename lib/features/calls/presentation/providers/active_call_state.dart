enum CallConnectionPhase {
  /// Fetching the call config, capturing media and joining the channel.
  connecting,

  /// Joined; the other party's media hasn't arrived yet.
  waiting,
  connected,
  reconnecting,
  failed,
}

class ActiveCallState {
  final CallConnectionPhase phase;
  final bool isMuted;
  final bool isCameraOff;
  final bool isSpeakerOn;
  final bool hasRemoteStream;
  final String? error;

  const ActiveCallState({
    this.phase = CallConnectionPhase.connecting,
    this.isMuted = false,
    this.isCameraOff = false,
    this.isSpeakerOn = false,
    this.hasRemoteStream = false,
    this.error,
  });

  ActiveCallState copyWith({
    CallConnectionPhase? phase,
    bool? isMuted,
    bool? isCameraOff,
    bool? isSpeakerOn,
    bool? hasRemoteStream,
    String? error,
  }) {
    return ActiveCallState(
      phase: phase ?? this.phase,
      isMuted: isMuted ?? this.isMuted,
      isCameraOff: isCameraOff ?? this.isCameraOff,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      hasRemoteStream: hasRemoteStream ?? this.hasRemoteStream,
      error: error ?? this.error,
    );
  }
}
