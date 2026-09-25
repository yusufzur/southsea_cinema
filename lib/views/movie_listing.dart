import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  const MovieListing({super.key});

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

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie title
            const Text(
              'EYES WIDE SHUT (1999) (18)',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 50),

            // Cinema room
            const Text(
              'Southsea Cinema Room',
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 25),

            // Date and time
            const Text(
              'Thursday 22 Oct 2026, 18:00 - ends at 20:39',
              style: TextStyle(fontSize: 18),
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

            Row(
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

                const Text(
                  'Adult (£7.50)',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                print('Adding $quantity ticket(s)');
              },
              child: const Text('ADD TO ORDER'),
            ),
          ],
        ),
      ),
    );
  }
} ////add the image of the movie poster to the top of the page, above the movie title. Use a placeholder image for now.