class CallException implements Exception {
  final String message;

  const CallException(this.message);

  @override
  String toString() => message;
}
