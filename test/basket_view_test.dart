import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  final basket = BasketRepository.instance;
  final movie = MovieRepository().getMovies().first;

  setUp(() async {
    basket.clear();
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

  Future<void> openBasket(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BasketView(),
        ),
      );
      await tester.pumpAndSettle();
    });

    await tester.pumpAndSettle();
  }

  testWidgets('BasketView displays an empty basket', (tester) async {
    await openBasket(tester);

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('CHECKOUT'), findsNothing);
  });

  testWidgets('BasketView displays and removes tickets', (tester) async {
    basket.addItem(
      BasketItem(movie: movie, quantity: 2),
    );

    await openBasket(tester);

    expect(find.text(movie.title), findsOneWidget);
    expect(find.text('Tickets: 2'), findsOneWidget);
    expect(find.text('£15.00'), findsWidgets);
    expect(find.text('CHECKOUT'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(basket.getItems(), isEmpty);
  });

  testWidgets('BasketView clears tickets on checkout', (tester) async {
    basket.addItem(
      BasketItem(movie: movie, quantity: 2),
    );

    await openBasket(tester);

    await tester.ensureVisible(find.text('CHECKOUT'));
    await tester.tap(find.text('CHECKOUT'));
    await tester.pump();

    expect(basket.getItems(), isEmpty);
    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(
      find.text('Thank you! Your booking has been received.'),
      findsOneWidget,
    );
  });

  testWidgets('BasketView displays saved bookings newest first', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await CinemaDatabase.instance.insertBooking(
        const Booking(
          bookingNumber: 1001,
          summary: '1 x Eyes Wide Shut',
          total: 7.50,
          date: '20/10/2026 12:00',
        ),
      );

      await CinemaDatabase.instance.insertBooking(
        const Booking(
          bookingNumber: 1002,
          summary: '2 x The Grand Budapest Hotel',
          total: 15.00,
          date: '21/10/2026 16:15',
        ),
      );
    });

    await openBasket(tester);

    expect(find.text('Past Bookings'), findsOneWidget);
    expect(find.text('Booking #1002'), findsOneWidget);
    expect(find.text('Booking #1001'), findsOneWidget);
    expect(find.text('2 x The Grand Budapest Hotel'), findsOneWidget);
    expect(find.text('1 x Eyes Wide Shut'), findsOneWidget);
    expect(find.text('£15.00'), findsOneWidget);
    expect(find.text('£7.50'), findsOneWidget);

    final double newestY = tester.getTopLeft(find.text('Booking #1002')).dy;
    final double oldestY = tester.getTopLeft(find.text('Booking #1001')).dy;

    expect(newestY, lessThan(oldestY));
  });

  testWidgets('BasketView shows a message when no bookings exist', (
    tester,
  ) async {
    await openBasket(tester);

    expect(find.text('Past Bookings'), findsOneWidget);
    expect(find.text('No bookings yet'), findsOneWidget);
  });
}
