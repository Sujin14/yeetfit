import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_theme.dart';
import 'package:yeetfit/shared/widgets/settings_tile.dart';

void main() {
  Widget harness(SettingsTile tile) {
    return ProviderScope(
      child: MaterialApp(theme: AppTheme.dark(), home: Scaffold(body: tile)),
    );
  }

  testWidgets('renders its label', (tester) async {
    await tester.pumpWidget(
      harness(
        const SettingsTile(
          icon: Icons.lock_outline,
          label: 'Privacy Policy',
          onTap: _noop,
        ),
      ),
    );

    expect(find.text('Privacy Policy'), findsOneWidget);
  });

  testWidgets('renders its icon', (tester) async {
    await tester.pumpWidget(
      harness(
        const SettingsTile(
          icon: Icons.lock_outline,
          label: 'Privacy Policy',
          onTap: _noop,
        ),
      ),
    );

    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });

  testWidgets('tapping calls onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      harness(
        SettingsTile(
          icon: Icons.lock_outline,
          label: 'Privacy Policy',
          onTap: () => taps++,
        ),
      ),
    );

    await tester.tap(find.text('Privacy Policy'));

    expect(taps, 1);
  });
}

void _noop() {}
