enum CallStatus {
  ringing,
  active,
  ended,
  missed,
  declined;

  /// Ended, missed or declined: the call can't be joined any more.
  bool get isFinished => this != ringing && this != active;
}
