import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/routes/app_routes.dart';
import 'features/chat/data/datasource/notification_service.dart';
import 'firebase_options.dart';
import 'shared/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('No user signed in');
    } else {
      print('User signed in: ${user.uid}');
    }
  });

  final container = ProviderContainer();
  await container.read(notificationServiceProvider).init();

  await _initStepCounter();

  runApp(const ProviderScope(child: YeetFitApp()));
}

Future<void> _initStepCounter() async {
  final status = await Permission.activityRecognition.request();
  if (!status.isGranted) {
    print('Step tracking permission not granted.');
    return;
  }

  try {
    Pedometer.stepCountStream.listen(
      (StepCount event) {
        print('Steps detected: ${event.steps}');
      },
      onError: (error) {
        print('Step stream error: $error');
      },
      cancelOnError: true,
    );
  } catch (e) {
    print('Error initializing step counter: $e');
  }
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
