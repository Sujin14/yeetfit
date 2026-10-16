import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'core/constants/notification_constants.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

/// Workmanager entry point. Runs in a fresh background isolate, so Firebase
/// must be initialised here before any task touches Firestore.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final userId = inputData?['userId'] as String?;
    if (userId == null) return false;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      if (task == NotificationConstants.waterReminderTask) {
        return await NotificationService().runWaterReminderCheck(userId);
      }
      return true;
    } catch (e) {
      debugPrint('Background task "$task" failed: $e');
      return false;
    }
  });
}

/// Builds before Health Connect registered these hourly pedometer tasks per
/// user; cancelling stops them waking the app for nothing.
Future<void> cancelLegacyStepsTasks(String userId) async {
  await Workmanager().cancelByUniqueName('midnight_$userId');
  await Workmanager().cancelByUniqueName('periodic_$userId');
}
