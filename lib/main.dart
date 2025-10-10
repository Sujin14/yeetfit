import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'core/routes/app_routes.dart';
import 'features/steps_tracking/presentation/providers/steps_provider.dart';
import 'features/chat/data/datasource/notification_service.dart';
import 'firebase_options.dart';
import 'shared/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final container = ProviderContainer();
  await container.read(notificationServiceProvider).init();

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await Workmanager().initialize(callbackDispatcher);

    // Initialize step counter
    final stepsInitializer = container.read(stepsInitializerProvider);
    await stepsInitializer.initStepCounter();

    // Schedule on auth change
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        if (kDebugMode) print('User signed in: ${user.uid}');
        stepsInitializer.scheduleWorkmanagerTask(user.uid);
      } else {
        if (kDebugMode) print('User signed out');
        // Optional: Cancel tasks (Workmanager().cancelAll();)
      }
    });
  } else {
    if (kDebugMode) {
      print("Workmanager not supported on Web/Desktop");
    }
  }

  runApp(const ProviderScope(child: YeetFitApp()));
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