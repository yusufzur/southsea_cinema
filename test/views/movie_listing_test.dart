import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

void main() {
  final basket = BasketRepository.instance;
  final movie = MovieRepository().getMovies().first;

  setUp(() {
    basket.clear();
  });

  testWidgets('Rejects adding zero tickets to basket', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MovieListing(movie: movie),
      ),
    );

    final orderButton = find.text('ADD TO ORDER');

    await tester.ensureVisible(orderButton);
    await tester.tap(orderButton);
    await tester.pump();

    expect(find.text('Please select at least 1 ticket'), findsOneWidget);
    expect(basket.getItems(), isEmpty);
  });

  testWidgets('Adds selected movie tickets to basket', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MovieListing(movie: movie),
      ),
    );

    final dropdown = find.byType(DropdownButton<int>);

    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();

    final orderButton = find.text('ADD TO ORDER');

    await tester.ensureVisible(orderButton);
    await tester.tap(orderButton);
    await tester.pump();

    expect(basket.getItems().length, 1);
    expect(basket.getItems().first.movie.id, movie.id);
    expect(basket.getItems().first.quantity, 2);
    expect(basket.getTotal(), 15.0);

    expect(
      find.text('Added 2 ticket(s) for ${movie.title} to basket'),
      findsOneWidget,
    );
  });
}
