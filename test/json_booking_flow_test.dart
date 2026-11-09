import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/views/basket_view.dart';

void main() {
  final basket = BasketRepository.instance;

  setUp(() {
    basket.clear();
    rootBundle.clear();
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

    await tester.pumpAndSettle();

    expect(find.byType(BasketView), findsOneWidget);
    expect(find.text('Eyes Wide Shut'), findsOneWidget);

    final checkoutButton = find.text('CHECKOUT');
    await tester.ensureVisible(checkoutButton);
    await tester.tap(checkoutButton);
    await tester.pumpAndSettle();

    expect(basket.getItems(), isEmpty);
    expect(
      find.text('Thank you! Your booking has been received.'),
      findsOneWidget,
    );
  });
}
