import 'package:flutter/material.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/constants.dart';

class MovieCard extends StatelessWidget {
  // Stores the movie information passed into this card
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      // Use the existing cinema theme colours
      color: cinemaSurface,
      margin: const EdgeInsets.all(16),

      child: Padding(
        padding: const EdgeInsets.all(16),

        // Makes the card responsive to different screen widths
        child: LayoutBuilder(
          builder: (context, constraints) {

            // Movie poster
            Widget poster = Image.asset(
              movie.imagePath,
              width: 180,
              height: 270,
              fit: BoxFit.cover,
            );

            // Movie information
            Widget movieDetails = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                // Movie title
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cinemaFontWhite,
                  ),
                ),

                const SizedBox(height: 8),

                // Year and age rating
                Text(
                  '${movie.year} | ${movie.ageRating}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: cinemaFontWhite,
                  ),
                ),

                const SizedBox(height: 12),

                // Movie description
                Text(
                  movie.synopsis,
                  style: const TextStyle(
                    fontSize: 16,
                    color: cinemaFontWhite,
                  ),
                ),

                const SizedBox(height: 12),

                // Screening time
                Text(
                  movie.screeningTime,
                  style: const TextStyle(
                    fontSize: 16,
                    color: cinemaFontWhite,
                  ),
                ),

                const SizedBox(height: 20),

                // Booking button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cinemaBrand,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    debugPrint('Booking ${movie.title}');
                  },
                  child: const Text('BOOK NOW'),
                ),
              ],
            );

            // Wide screens: poster and information side by side
            if (constraints.maxWidth > 600) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  poster,

                  const SizedBox(width: 24),

                  Expanded(
                    child: movieDetails,
                  ),
                ],
              );
            }

            // Narrow screens: poster above information
            else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  poster,

                  const SizedBox(height: 16),

                  movieDetails,
                ],
              );
            }
          },
        ),
      ),
    );
  }
}