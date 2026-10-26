
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';

void main() {
  final basket = BasketRepository.instance;
  final movie = MovieRepository().getMovies().first;

  setUp(() {
    basket.clear();
  });

  testWidgets('BasketView displays an empty basket', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BasketView(),
      ),
    );

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('CHECKOUT'), findsNothing);
  });

  testWidgets('BasketView displays and removes tickets', (tester) async {
    basket.addItem(
      BasketItem(movie: movie, quantity: 2),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: BasketView(),
      ),
    );

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

    await tester.pumpWidget(
      const MaterialApp(
        home: BasketView(),
      ),
    );

    await tester.tap(find.text('CHECKOUT'));
    await tester.pump();

    expect(basket.getItems(), isEmpty);
    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(
      find.text('Thank you! Your booking has been received.'),
      findsOneWidget,
    );
  });
}
