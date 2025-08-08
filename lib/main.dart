import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

import 'core/routes/app_routes.dart';
import 'features/chat/data/datasource/notification_service.dart';
import 'features/steps_tracking/presentation/providers/steps_provider.dart';
import 'firebase_options.dart';
import 'shared/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Workmanager
  await Workmanager().initialize(
    callbackDispatcher,
  );

  final container = ProviderContainer();
  await container.read(notificationServiceProvider).init();

  await _initStepCounter();

  // Schedule Workmanager task for authenticated users
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      if (kDebugMode) {
        print('User signed in: ${user.uid}');
      }
      Workmanager().registerPeriodicTask(
        midnightResetTask,
        midnightResetTask,
        inputData: {'userId': user.uid},
        frequency: const Duration(hours: 24),
        initialDelay: _calculateInitialDelay(),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } else {
      if (kDebugMode) {
        print('No user signed in');
      }
    }
  });

  runApp(const ProviderScope(child: YeetFitApp()));
}

Future<void> _initStepCounter() async {
  final status = await Permission.activityRecognition.request();
  if (!status.isGranted) {
    if (kDebugMode) {
      print('Step tracking permission not granted.');
    }
    return;
  }

  try {
    // Initialize pedometer stream for testing (optional, can be managed by StepsCountNotifier)
    Pedometer.stepCountStream.listen(
      (StepCount event) {
        if (kDebugMode) {
          print('Steps detected: ${event.steps}');
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Step stream error: $error');
        }
      },
      cancelOnError: true,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing step counter: $e');
    }
  }
}

Duration _calculateInitialDelay() {
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day + 1);
  return midnight.difference(now);
}

class YeetFitApp extends StatelessWidget {
  const YeetFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 873),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: AppTheme.getLightTheme(),
      ),
    );
  }
}