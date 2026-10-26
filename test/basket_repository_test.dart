
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  final basket = BasketRepository.instance;
  final movies = MovieRepository().getMovies();

  setUp(() {
    basket.clear();
  });

  group('BasketRepository tests', () {
    test('starts with an empty basket', () {
      expect(basket.getItems(), isEmpty);
      expect(basket.getTotalItems(), 0);
      expect(basket.getTotal(), 0.0);
    });

    test('adds tickets and calculates totals correctly', () {
      basket.addItem(BasketItem(movie: movies[0], quantity: 2));
      basket.addItem(BasketItem(movie: movies[1], quantity: 3));

      expect(basket.getItems().length, 2);
      expect(basket.getTotalItems(), 5);
      expect(basket.getTotal(), 37.50);
    });

    test('removes tickets from the basket', () {
      basket.addItem(BasketItem(movie: movies[0], quantity: 2));

      expect(basket.getItems().length, 1);

      basket.removeItem(0);

      expect(basket.getItems(), isEmpty);
      expect(basket.getTotal(), 0.0);
    });

    test('clears all tickets from the basket', () {
      basket.addItem(BasketItem(movie: movies[0], quantity: 2));
      basket.addItem(BasketItem(movie: movies[1], quantity: 1));

      basket.clear();

      expect(basket.getItems(), isEmpty);
      expect(basket.getTotalItems(), 0);
      expect(basket.getTotal(), 0.0);
    });
  });
}
