import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  group('MovieRepository', () {
    final repo = MovieRepository();

    test('returns at least two valid movies with unique IDs', () {
      final movies = repo.getMovies();
      expect(movies.length, greaterThanOrEqualTo(2));
      expect(movies.map((m) => m.id).toSet().length, movies.length);
      for (final movie in movies) {
        expect(movie.id, isNotEmpty);
        expect(movie.title, isNotEmpty);
        expect(movie.ageRating, isNotEmpty);
        expect(movie.ticketPrice, greaterThan(0));
      }
    });

    test('finds an existing ID and rejects missing IDs', () {
      expect(repo.getMovieById('eyes-wide-shut')?.title, 'Eyes Wide Shut');
      expect(repo.getMovieById('missing-film'), isNull);
    });

    test('filters by age rating', () {
      final results = repo.getMoviesByAgeRating('18');
      expect(results.every((m) => m.ageRating == '18'), isTrue);
    });

    test('filters films below a price', () {
      final results = repo.getMoviesUnderPrice(8.0);
      expect(results.every((m) => m.ticketPrice < 8.0), isTrue);
    });
  });
}
