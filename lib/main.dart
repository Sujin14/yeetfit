import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yeetfit/shared/theme/app_theme_mode.dart';
import 'core/routes/app_routes.dart';
import 'firebase_options.dart';

final roleProvider = StateProvider<AppRole>(
  (ref) => AppRole.user,
); // used for testing the ui. should change it after completing the user roles in firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: YeetFitApp()));
}

class YeetFitApp extends ConsumerWidget {
  const YeetFitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.getLightTheme(role),
      darkTheme: ThemeData.dark(),
    );
  }
}
