import '../../domain/entities/call_participant.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_status.dart';
import '../../domain/entities/call_type.dart';
import '../../domain/repositories/call_repository.dart';
import '../datasources/call_datasource.dart';
import '../datasources/metered_config_datasource.dart';

class CallRepositoryImpl implements CallRepository {
  final CallDataSource _callDataSource;
  final MeteredConfigDataSource _configDataSource;

  const CallRepositoryImpl({
    required CallDataSource callDataSource,
    required MeteredConfigDataSource configDataSource,
  }) : _callDataSource = callDataSource,
       _configDataSource = configDataSource;

  @override
  Future<CallParticipant> getParticipant(String userId) =>
      _callDataSource.getParticipant(userId);

  @override
  Future<CallSession> initiateCall({
    required CallParticipant caller,
    required CallParticipant receiver,
    required CallType type,
  }) => _callDataSource.createCall(
    caller: caller,
    receiver: receiver,
    type: type,
  );

  @override
  Future<void> acceptCall(String callId) => _callDataSource.transition(
    callId,
    next: CallStatus.active,
    allowedFrom: {CallStatus.ringing},
  );

  @override
  Future<void> declineCall(String callId) => _callDataSource.transition(
    callId,
    next: CallStatus.declined,
    allowedFrom: {CallStatus.ringing},
  );

  @override
  Future<void> endCall(String callId) => _callDataSource.transition(
    callId,
    next: CallStatus.ended,
    allowedFrom: {CallStatus.ringing, CallStatus.active},
  );

  @override
  Future<void> markMissed(String callId) => _callDataSource.transition(
    callId,
    next: CallStatus.missed,
    allowedFrom: {CallStatus.ringing},
  );

  @override
  Stream<CallSession?> watchIncomingCall(String userId) =>
      _callDataSource.watchIncomingCall(userId);

  @override
  Stream<CallSession?> watchCall(String callId) =>
      _callDataSource.watchCall(callId);

  @override
  Future<CallSession?> getCall(String callId) =>
      _callDataSource.getCall(callId);

  @override
  Future<String> getRealtimeApiKey() => _configDataSource.getApiKey();
}
