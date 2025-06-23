import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/auth/presentation/splash_screen.dart';
import 'package:yeetfit/shared/theme/app_theme_mode.dart';

void main() {
  runApp(const ProviderScope(child: YeetFitApp()));
}

final roleProvider = StateProvider<AppRole>((ref) => AppRole.user);

class YeetFitApp extends ConsumerWidget {
  const YeetFitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getLightTheme(role),
      darkTheme: AppTheme.getDarkTheme(role),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
