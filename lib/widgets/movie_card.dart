import 'package:flutter/material.dart';
import 'package:southsea_cinema/models/movie.dart';

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
      margin: const EdgeInsets.all(16),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Movie poster
            Image.asset(
              movie.imagePath,
              width: 180,
              height: 270,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            // Movie title
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Year and age rating
            Text(
              '${movie.year} | ${movie.ageRating}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            // Movie description
            Text(
              movie.synopsis,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            // Screening time
            Text(
              movie.screeningTime,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Booking button
            ElevatedButton(
              onPressed: () {
                debugPrint('Booking ${movie.title}');
              },
              child: const Text('BOOK NOW'),
            ),
          ],
        ),
      ),
    );
  }
}