import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Call id accepted from the system UI before [runApp], if any.
/// Overridden in `main()` so splash can route to `/joining-call/:callId`
/// without painting the dashboard first.
final pendingAcceptedCallIdProvider = Provider<String?>((ref) => null);
