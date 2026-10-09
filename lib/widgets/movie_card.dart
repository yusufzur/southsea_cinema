import 'package:flutter/material.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cinemaSurface,
      margin: const EdgeInsets.all(16),

      child: Padding(
        padding: const EdgeInsets.all(16),

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

                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cinemaFontWhite,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${movie.year} | ${movie.ageRating}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: cinemaFontWhite,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  movie.synopsis,
                  style: const TextStyle(
                    fontSize: 16,
                    color: cinemaFontWhite,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  movie.screeningTime,
                  style: const TextStyle(
                    fontSize: 16,
                    color: cinemaFontWhite,
                  ),
                ),

                const SizedBox(height: 20),

                // Booking button - opens the selected movie
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cinemaBrand,
                    foregroundColor: Colors.black,
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieListing(
                          movie: movie,
                        ),
                      ),
                    );
                  },

                  child: const Text('BOOK NOW'),
                ),
              ],
            );

            // Wide screens
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

            // Narrow screens
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