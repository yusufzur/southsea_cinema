import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  final Movie movie;

  const MovieListing({
    super.key,
    required this.movie,
  });

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                widget.movie.imagePath,
                width: 180,
                height: 270,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 20),

              Text(
                '${widget.movie.title.toUpperCase()} '
                '(${widget.movie.year}) '
                '(${widget.movie.ageRating})',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 50),

              Text(
                widget.movie.room,
                style: const TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 25),

              Text(
                '${widget.movie.screeningTime} '
                '- ends at ${widget.movie.endTime}',
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 60),

              const Text(
                'Please note that Discounts / Membership Benefits '
                'will be applied once you have selected your tickets',
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 25),

              const Text(
                'Select Quantities (Up to 5 in total)',
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 50),

              const Text(
                'Tickets',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Responsive ticket controls
              LayoutBuilder(
                builder: (context, constraints) {
                  Widget ticketSelector = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<int>(
                        value: quantity,
                        items: [0, 1, 2, 3, 4, 5].map((number) {
                          return DropdownMenuItem<int>(
                            value: number,
                            child: Text('$number'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            quantity = value!;
                          });
                        },
                      ),

                      const SizedBox(width: 20),

                      Text(
                        'Adult (£${widget.movie.ticketPrice.toStringAsFixed(2)})',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  );

                  Widget orderButton = ElevatedButton(
                    onPressed: () {
                      debugPrint(
                        'Adding $quantity ticket(s) for ${widget.movie.title}',
                      );
                    },
                    child: const Text('ADD TO ORDER'),
                  );

                  if (constraints.maxWidth > 600) {
                    return Row(
                      children: [
                        ticketSelector,
                        const SizedBox(width: 40),
                        orderButton,
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ticketSelector,
                        const SizedBox(height: 20),
                        orderButton,
                      ],
                    );
                  }
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}