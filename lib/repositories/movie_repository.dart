import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie>? _cachedMovies;

  List<Movie> getMovies() {
    final List<Movie>? cachedMovies = _cachedMovies;

    if (cachedMovies != null) {
      return cachedMovies;
    }

    return const [
      Movie(
        id: 'eyes-wide-shut',
        title: 'Eyes Wide Shut',
        year: 1999,
        ageRating: '18',
        synopsis: 'A psychological mystery directed by Stanley Kubrick.',
        room: 'Southsea Cinema Room',
        screeningTime: 'Thursday 22 Oct 2026, 18:00',
        endTime: '20:39',
        ticketPrice: 7.50,
        imagePath: 'assets/images/eyes_wide_shut.jpg',
      ),
      Movie(
        id: 'the-grand-budapest-hotel',
        title: 'The Grand Budapest Hotel',
        year: 2014,
        ageRating: '15',
        synopsis: 'A quirky comedy about a famous hotel concierge.',
        room: 'Southsea Cinema Room',
        screeningTime: 'Friday 23 Oct 2026, 18:00',
        endTime: '20:49',
        ticketPrice: 7.50,
        imagePath: 'assets/images/the_grand_budapest_hotel.jpg',
      ),
    ];
  }

  Future<List<Movie>> loadMoviesFromAsset({
    String assetPath = 'assets/data/movies.json',
  }) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;
    final List<Movie> loadedMovies = [];

    for (final dynamic item in jsonList) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final Movie movie = Movie.fromJson(itemMap);
      loadedMovies.add(movie);
    }

    _cachedMovies = loadedMovies;
    return loadedMovies;
  }

  Movie? getMovieById(String id) {
    for (final movie in getMovies()) {
      if (movie.id == id) return movie;
    }
    return null;
  }

  List<Movie> getMoviesByAgeRating(String rating) =>
      getMovies().where((movie) => movie.ageRating == rating).toList();

  List<Movie> getMoviesUnderPrice(double maxPrice) =>
      getMovies().where((movie) => movie.ticketPrice < maxPrice).toList();
}
