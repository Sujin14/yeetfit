import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/call_datasource.dart';
import '../../data/datasources/metered_config_datasource.dart';
import '../../data/repositories/call_repository_impl.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/repositories/call_repository.dart';

final callRepositoryProvider = Provider<CallRepository>((ref) {
  return CallRepositoryImpl(
    callDataSource: CallDataSource(),
    configDataSource: MeteredConfigDataSource(),
  );
});

/// Realtime messaging API key from the `getCallConfig` Cloud Function.
/// Invalidate after a failure so the next call retries.
final meteredConfigProvider = FutureProvider<String>(
  (ref) => ref.read(callRepositoryProvider).getRealtimeApiKey(),
);

/// Live copy of a call document, keyed by call id.
final activeCallProvider = StreamProvider.autoDispose
    .family<CallSession?, String>(
      (ref, callId) => ref.read(callRepositoryProvider).watchCall(callId),
    );
