import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    //Get movies from the repository
    final movies = MovieRepository().getMovies();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appTitle,
          style: cinemaHeaderStyle,
        ),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),

      drawer: const NavDrawer(),

      body: Column(
        children: [

          // Welcome message
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Welcome to $appTitle',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //Display movies using ListView.builder
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,

              itemBuilder: (context, index) {
                return MovieCard(
                  movie: movies[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}