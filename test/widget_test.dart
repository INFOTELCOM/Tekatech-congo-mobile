import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tekatech_congo_app/screens/splash_screen.dart';

void main() {
  testWidgets(
    'L’écran de démarrage de TekaTech Congo se construit correctement',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );

      expect(find.byType(SplashScreen), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
    },
  );
}