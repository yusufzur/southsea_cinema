
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/user_settings.dart';

void main() {
  group('UserSettings tests', () {
    test('uses default values when no settings are provided', () {
      const settings = UserSettings();

      expect(settings.name, isEmpty);
      expect(settings.address, isEmpty);
      expect(settings.email, isEmpty);
      expect(settings.receiveNewsletter, isFalse);
    });

    test('stores the values provided by the user', () {
      const settings = UserSettings(
        name: 'Yusuf Ziya',
        address: '221B Baker Street, London',
        email: 'yusuf@example.com',
        receiveNewsletter: true,
      );

      expect(settings.name, 'Yusuf Ziya');
      expect(settings.address, '221B Baker Street, London');
      expect(settings.email, 'yusuf@example.com');
      expect(settings.receiveNewsletter, isTrue);
    });
  });
}
