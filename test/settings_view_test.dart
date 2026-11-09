import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('SettingsView displays all profile fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );
    await tester.pumpAndSettle();

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
    await tester.pumpAndSettle();

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
    await tester.pumpAndSettle();

    expect(
      find.text('Settings saved for Yusuf Ziya'),
      findsOneWidget,
    );

    final prefs = SharedPreferencesAsync();

    expect(await prefs.getString(prefName), 'Yusuf Ziya');
    expect(await prefs.getString(prefAddress), '221B Baker Street, London');
    expect(await prefs.getString(prefEmail), 'yusuf@example.com');
    expect(await prefs.getBool(prefNewsletter), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Yusuf Ziya'), findsOneWidget);
    expect(find.text('221B Baker Street, London'), findsOneWidget);
    expect(find.text('yusuf@example.com'), findsOneWidget);

    final reopenedSwitch = tester.widget<Switch>(find.byType(Switch));
    expect(reopenedSwitch.value, isTrue);
  });

  testWidgets('SettingsView loads previously saved preferences',
      (tester) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefName: 'Alex Morgan',
      prefAddress: '10 Example Street, London',
      prefEmail: 'alex@example.com',
      prefNewsletter: true,
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Alex Morgan'), findsOneWidget);
    expect(find.text('10 Example Street, London'), findsOneWidget);
    expect(find.text('alex@example.com'), findsOneWidget);

    final newsletterSwitch = tester.widget<Switch>(find.byType(Switch));
    expect(newsletterSwitch.value, isTrue);
  });
}
