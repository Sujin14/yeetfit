import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeetfit/core/routes/call_route_constants.dart';
import 'package:yeetfit/core/routes/shell_route_constants.dart';
import 'package:yeetfit/core/services/call_native_service.dart';
import '../providers/call_provider.dart';

/// Black hold screen used on cold-start accept. Loads the call, then replaces
/// itself with [ActiveCallScreen] so the dashboard never paints.
class JoiningCallScreen extends ConsumerStatefulWidget {
  const JoiningCallScreen({required this.callId, super.key});

  final String callId;

  @override
  ConsumerState<JoiningCallScreen> createState() => _JoiningCallScreenState();
}

class _JoiningCallScreenState extends ConsumerState<JoiningCallScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _join());
  }

  Future<void> _join() async {
    debugPrint('[YeetCall] JoiningCallScreen init: callId=${widget.callId}');
    if (widget.callId.startsWith('test_')) {
      await CallNativeService.clearLockScreenFlags();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(CallNativeService.prefsCallSetupTestPassed, true);
      if (mounted) context.go(CallRouteConstants.callSetup);
      return;
    }
    final repository = ref.read(callRepositoryProvider);
    try {
      await repository.acceptCall(widget.callId);
    } catch (e) {
      debugPrint(
        '[YeetCall] JoiningCallScreen: acceptCall failed ($e) — going to dashboard',
      );
      await CallNativeService.dismissIncomingCall(widget.callId);
      await CallNativeService.clearLockScreenFlags();
      if (mounted) context.go(ShellRouteConstants.dashboard);
      return;
    }
    final call = await repository.getCall(widget.callId);
    if (!mounted || call == null) {
      if (mounted) context.go(ShellRouteConstants.dashboard);
      return;
    }
    debugPrint('[YeetCall] JoiningCallScreen: navigating to active call');
    context.go(CallRouteConstants.activeCallPath(call.id), extra: call);
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(backgroundColor: Colors.black);
}
