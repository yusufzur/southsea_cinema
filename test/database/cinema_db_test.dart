import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUp(() async {
    sqfliteFfiInit();

    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: CinemaDatabase.instance.createTables,
      ),
    );

    CinemaDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await CinemaDatabase.instance.close();
  });

  Booking buildBooking(int bookingNumber, String summary, double total) {
    return Booking(
      bookingNumber: bookingNumber,
      summary: summary,
      total: total,
      date: '11/11/2026 15:00',
    );
  }

  group('CinemaDatabase tests', () {
    test('inserts and retrieves a booking', () async {
      final int id = await CinemaDatabase.instance.insertBooking(
        buildBooking(1001, '2 x Eyes Wide Shut', 15.00),
      );

      expect(id, greaterThan(0));

      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();

      expect(bookings.length, 1);
      expect(bookings[0].id, id);
      expect(bookings[0].bookingNumber, 1001);
      expect(bookings[0].summary, '2 x Eyes Wide Shut');
      expect(bookings[0].total, 15.00);
    });

    test('calculates the next booking number', () async {
      expect(
        await CinemaDatabase.instance.getNextBookingNumber(),
        1001,
      );

      await CinemaDatabase.instance.insertBooking(
        buildBooking(1005, '1 x The Grand Budapest Hotel', 7.50),
      );

      expect(
        await CinemaDatabase.instance.getNextBookingNumber(),
        1006,
      );
    });

    test('retrieves bookings in descending order', () async {
      await CinemaDatabase.instance.insertBooking(
        buildBooking(1001, 'First booking', 7.50),
      );

      await CinemaDatabase.instance.insertBooking(
        buildBooking(1003, 'Third booking', 22.50),
      );

      await CinemaDatabase.instance.insertBooking(
        buildBooking(1002, 'Second booking', 15.00),
      );

      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();

      expect(bookings.length, 3);
      expect(bookings[0].bookingNumber, 1003);
      expect(bookings[1].bookingNumber, 1002);
      expect(bookings[2].bookingNumber, 1001);
    });
  });
}
