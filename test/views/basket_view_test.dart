import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/movie.dart';
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

  testWidgets('Checkout saves booking and clears the basket', (tester) async {
    basket.addItem(
      BasketItem(movie: movie, quantity: 2),
    );

    await openBasket(tester);

    await tester.ensureVisible(find.text('CHECKOUT'));

    await tester.runAsync(() async {
      await tester.tap(find.text('CHECKOUT'));
      await tester.pumpAndSettle();
    });

    await tester.pumpAndSettle();

    final List<Booking>? bookings = await tester.runAsync(() async {
      return await CinemaDatabase.instance.getAllBookings();
    });

    expect(bookings, isNotNull);

    if (bookings != null) {
      expect(bookings.length, 1);
      expect(bookings[0].bookingNumber, 1001);
      expect(bookings[0].summary, '2 x Eyes Wide Shut');
      expect(bookings[0].total, 15.00);
    }

    expect(basket.getItems(), isEmpty);
    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Booking #1001 saved'), findsOneWidget);
    expect(find.text('Booking #1001'), findsOneWidget);
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

  testWidgets('Checkout keeps the basket when saving fails', (tester) async {
    basket.addItem(
      BasketItem(movie: movie, quantity: 2),
    );

    await openBasket(tester);

    await tester.runAsync(() async {
      final Database database = await CinemaDatabase.instance.database;
      await database.execute('DROP TABLE bookings');
    });

    await tester.ensureVisible(find.text('CHECKOUT'));

    await tester.runAsync(() async {
      await tester.tap(find.text('CHECKOUT'));
      await tester.pumpAndSettle();
    });

    await tester.pumpAndSettle();

    expect(basket.getItems().length, 1);
    expect(basket.getTotalItems(), 2);
    expect(basket.getTotalDue(), 15.00);
    expect(find.text('Eyes Wide Shut'), findsOneWidget);
    expect(
      find.textContaining('Could not save your booking'),
      findsOneWidget,
    );
  });

  testWidgets('Removes the middle item from a basket of three', (
    tester,
  ) async {
    final movies = MovieRepository().getMovies();

    final Movie firstMovie = movies.first;
    final Movie secondMovie = movies.last;

    // Create a third film for testing purposes only.
    final Movie thirdMovie = Movie.fromJson({
      ...firstMovie.toJson(),
      'id': 'third-test-film',
      'title': 'Third Test Film',
    });

    // Add three different items to the basket.
    basket.addItem(
      BasketItem(movie: firstMovie, quantity: 1),
    );

    basket.addItem(
      BasketItem(movie: secondMovie, quantity: 2),
    );

    basket.addItem(
      BasketItem(movie: thirdMovie, quantity: 3),
    );

    expect(basket.getItems(), hasLength(3));
    expect(basket.getTotalItems(), 6);

    await openBasket(tester);

    // Check that all three films are displayed.
    expect(find.text(firstMovie.title), findsOneWidget);
    expect(find.text(secondMovie.title), findsOneWidget);
    expect(find.text(thirdMovie.title), findsOneWidget);

    // Delete the middle item using its unique Key.
    final middleDeleteButton = find.byKey(
      const Key('remove-ticket-1'),
    );

    await tester.ensureVisible(middleDeleteButton);
    await tester.tap(middleDeleteButton);
    await tester.pump();

    // Check that only two items remain.
    final remainingItems = basket.getItems();

    expect(remainingItems, hasLength(2));

    // Verify the first and third films remain in order.
    expect(remainingItems[0].movie.id, firstMovie.id);
    expect(remainingItems[1].movie.id, thirdMovie.id);

    // Verify their quantities are unchanged.
    expect(remainingItems[0].quantity, 1);
    expect(remainingItems[1].quantity, 3);
    expect(basket.getTotalItems(), 4);

    // Verify that the UI displays the correct films.
    expect(find.text(firstMovie.title), findsOneWidget);
    expect(find.text(secondMovie.title), findsNothing);
    expect(find.text(thirdMovie.title), findsOneWidget);

    // Check that the remaining basket items can still be deleted.
    expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));
  });
}
