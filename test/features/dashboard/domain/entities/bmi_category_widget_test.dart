import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_theme.dart';
import 'package:yeetfit/features/dashboard/presentation/providers/bmi_provider.dart';
import 'package:yeetfit/features/dashboard/presentation/widgets/dashboard_bmi_card.dart';

void main() {
  const userId = 'user';

  Future<void> pumpBmi(WidgetTester tester, double bmi) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bmiStreamProvider(userId).overrideWith((ref) => Stream.value(bmi)),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: const Scaffold(
            body: DashboardBmiCard(userId: userId, onCompleteProfile: _noop),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('underweight BMI shows the Underweight label', (tester) async {
    await pumpBmi(tester, 16);

    expect(find.text('Underweight'), findsOneWidget);
    expect(_labelColor(tester, 'Underweight'), AppColors.dark.bmiUnderweight);
  });

  testWidgets('normal BMI shows the Normal label', (tester) async {
    await pumpBmi(tester, 22);

    expect(find.text('Normal'), findsOneWidget);
    expect(_labelColor(tester, 'Normal'), AppColors.dark.bmiNormal);
  });

  testWidgets('overweight BMI shows the Overweight label', (tester) async {
    await pumpBmi(tester, 27);

    expect(find.text('Overweight'), findsOneWidget);
    expect(_labelColor(tester, 'Overweight'), AppColors.dark.bmiOverweight);
  });

  testWidgets('obese BMI shows the Obesity label', (tester) async {
    await pumpBmi(tester, 32);

    expect(find.text('Obesity'), findsOneWidget);
    expect(_labelColor(tester, 'Obesity'), AppColors.dark.bmiObese);
  });
}

void _noop() {}

Color? _labelColor(WidgetTester tester, String label) {
  return tester.widget<Text>(find.text(label)).style?.color;
}
