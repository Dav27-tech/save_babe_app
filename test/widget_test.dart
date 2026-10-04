import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_babe/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter Tests', () {
    test('weeksOf returns valid clamped weeks', () {
      final now = DateTime.now();
      final lmp = now.subtract(const Duration(days: 140)).toIso8601String();
      final weeks = DateFormatter.weeksOf(lmp);
      expect(weeks, equals(20));
    });

    test('weeksOf defaults to 24 on empty lmp', () {
      expect(DateFormatter.weeksOf(''), equals(24));
    });

    test('trimester calculates correct trimester', () {
      expect(DateFormatter.trimester(8), equals(1));
      expect(DateFormatter.trimester(20), equals(2));
      expect(DateFormatter.trimester(32), equals(3));
    });
  });

  testWidgets('Date picker opens with French Material localizations', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                locale: const Locale('fr', 'FR'),
              ),
              child: const Text('Choisir la date'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Choisir la date'));
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
}
