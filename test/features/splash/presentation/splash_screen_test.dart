import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_theme.dart';
import 'package:yeetfit/features/splash/presentation/screens/splash_screen.dart';

void main() {
  Future<void> pumpSplash(WidgetTester tester) {
    return tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: SplashScreen(readCurrentUser: () => null),
        ),
      ),
    );
  }

  /// The splash schedules image decode and navigation timers. Drop the screen
  /// and let those timers finish so the test ends cleanly.
  Future<void> finishSplash(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 4));
  }

  testWidgets('splash screen renders without throwing', (tester) async {
    await pumpSplash(tester);

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    await finishSplash(tester);
  });

  testWidgets('shows the Yeetfit name', (tester) async {
    await pumpSplash(tester);

    expect(find.text('Yeetfit'), findsOneWidget);

    await finishSplash(tester);
  });

  testWidgets('shows the tagline', (tester) async {
    await pumpSplash(tester);

    expect(find.text('Your fitness, tracked.'), findsOneWidget);

    await finishSplash(tester);
  });
}
