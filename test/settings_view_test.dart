import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  testWidgets('SettingsView displays all profile fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );

    expect(find.text('Customer Profile'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('SAVE SETTINGS'), findsOneWidget);
  });

  testWidgets('SettingsView saves entered details and newsletter preference',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );

    final nameField = find.widgetWithText(TextField, 'Full name');
    final addressField = find.widgetWithText(TextField, 'Delivery address');
    final emailField = find.widgetWithText(TextField, 'Email address');

    await tester.enterText(nameField, 'Yusuf Ziya');
    await tester.enterText(addressField, '221B Baker Street, London');
    await tester.enterText(emailField, 'yusuf@example.com');

    final newsletterSwitch = find.byType(Switch);

    expect(tester.widget<Switch>(newsletterSwitch).value, isFalse);

    await tester.ensureVisible(newsletterSwitch);
    await tester.tap(newsletterSwitch);
    await tester.pump();

    expect(tester.widget<Switch>(newsletterSwitch).value, isTrue);

    final saveButton = find.text('SAVE SETTINGS');

    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pump();

    expect(
      find.text('Settings saved for Yusuf Ziya'),
      findsOneWidget,
    );
  });
}
