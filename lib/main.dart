import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
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
