import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workmanager/workmanager.dart';
import 'app_startup.dart';
import 'background_task_dispatcher.dart';
import 'core/routes/app_routes.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inter is bundled in assets/fonts. Only weights 400–700 are bundled, so
  // any other weight fails to load instead of being downloaded.
  GoogleFonts.config.allowRuntimeFetching = false;
  final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  // Must be registered before Firebase.initializeApp().
  if (isMobile) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Must run before the first Firestore read. Streams then emit cached
  // documents immediately, including while offline.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  if (isMobile) {
    await Workmanager().initialize(callbackDispatcher);
  }

  runApp(const ProviderScope(child: AppStartup(child: YeetFitApp())));
}

class YeetFitApp extends StatelessWidget {
  const YeetFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
    );
  }
}
