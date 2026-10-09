import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
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
}