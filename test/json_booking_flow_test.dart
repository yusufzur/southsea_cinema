import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  final basket = BasketRepository.instance;

  setUp(() async {
    basket.clear();
    rootBundle.clear();

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

  testWidgets('Books a JSON-loaded movie and completes checkout', (
    tester,
  ) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    expect(find.text('Eyes Wide Shut'), findsOneWidget);

    final bookButton = find.text('BOOK NOW').first;
    await tester.ensureVisible(bookButton);
    await tester.tap(bookButton);
    await tester.pumpAndSettle();

    expect(find.byType(MovieListing), findsOneWidget);

    final dropdown = find.byType(DropdownButton<int>);
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();

    final addButton = find.text('ADD TO ORDER');
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pump();

    expect(basket.getTotalItems(), 2);
    expect(basket.getTotalDue(), 15.0);
    expect(basket.getItems().first.movie.id, 'eyes-wide-shut');

    ScaffoldMessenger.of(
      tester.element(find.byType(MovieListing)),
    ).removeCurrentSnackBar();

    await tester.pumpAndSettle();

    Navigator.of(
      tester.element(find.byType(MovieListing)),
    ).pushNamed('/basket');

    await tester.runAsync(() async {
      await tester.pumpAndSettle();
    });

    await tester.pumpAndSettle();

    expect(find.byType(BasketView), findsOneWidget);
    expect(find.text('Eyes Wide Shut'), findsOneWidget);

    final checkoutButton = find.text('CHECKOUT');
    await tester.ensureVisible(checkoutButton);

    await tester.runAsync(() async {
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();
    });

    await tester.pumpAndSettle();

    final List<Booking>? bookings = await tester.runAsync(() async {
      return await CinemaDatabase.instance.getAllBookings();
    });

    expect(bookings, isNotNull);
    expect(bookings, hasLength(1));
    expect(bookings![0].bookingNumber, 1001);
    expect(bookings[0].summary, '2 x Eyes Wide Shut');
    expect(bookings[0].total, 15.00);

    expect(basket.getItems(), isEmpty);
    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Booking #1001 saved'), findsOneWidget);
    expect(find.text('Booking #1001'), findsOneWidget);
  });
}
