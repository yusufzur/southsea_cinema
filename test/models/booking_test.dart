import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/booking.dart';

void main() {
  group('Booking model tests', () {
    const Booking booking = Booking(
      bookingNumber: 1004,
      summary: '2 x Eyes Wide Shut',
      total: 15.00,
      date: '11/11/2026 15:00',
    );

    test('new bookings have no ID and convert to a map', () {
      expect(booking.id, isNull);

      expect(booking.toMap(), {
        'booking_number': 1004,
        'summary': '2 x Eyes Wide Shut',
        'total': 15.00,
        'date': '11/11/2026 15:00',
      });
    });

    test('converts a database row into a Booking', () {
      final Map<String, Object?> row = {
        'id': 7,
        'booking_number': 1010,
        'summary': '1 x The Grand Budapest Hotel',
        'total': 7.50,
        'date': '12/11/2026 18:30',
      };

      final Booking restored = Booking.fromMap(row);

      expect(restored.id, 7);
      expect(restored.bookingNumber, 1010);
      expect(restored.summary, '1 x The Grand Budapest Hotel');
      expect(restored.total, 7.50);
      expect(restored.date, '12/11/2026 18:30');
      expect(restored.toMap(), row);
    });

    test('converts whole-number totals into doubles', () {
      final Map<String, Object?> row = booking.toMap();
      row['total'] = 15;

      final Booking restored = Booking.fromMap(row);

      expect(restored.total, 15.0);
      expect(restored.total, isA<double>());
    });
  });
}
