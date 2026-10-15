import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie model tests', () {
    // Test 1: Check movie properties
    test('creates Movie with correct properties', () {
      const movie = Movie(
        id: 'eyes-wide-shut',
        title: 'Eyes Wide Shut',
        year: 1999,
        ageRating: '18',
        synopsis: 'A psychological mystery',
        room: 'Southsea Cinema Room',
        screeningTime: 'Thursday 22 Oct 2026, 18:00',
        endTime: '20:39',
        ticketPrice: 7.50,
        imagePath: 'assets/images/eyes_wide_shut.jpg',
      );

      expect(movie.id, 'eyes-wide-shut');
      expect(movie.title, 'Eyes Wide Shut');
      expect(movie.year, 1999);
      expect(movie.ageRating, '18');
      expect(movie.ticketPrice, 7.50);
      expect(movie.imagePath, 'assets/images/eyes_wide_shut.jpg');
    });

    // Test 2: Check formatted ticket price
    test('formats ticket price correctly', () {
      const movie = Movie(
        id: 'test-movie',
        title: 'Test Movie',
        year: 2026,
        ageRating: 'PG',
        synopsis: 'Test description',
        room: 'Room 1',
        screeningTime: '18:00',
        endTime: '20:00',
        ticketPrice: 6.0,
        imagePath: 'assets/images/test.jpg',
      );

      expect(movie.formattedPrice, '£6.00');
    });

    // Test 3: Check child-friendly age ratings
    test('identifies child-friendly movies', () {
      const movie = Movie(
        id: 'family-movie',
        title: 'Family Movie',
        year: 2026,
        ageRating: 'PG',
        synopsis: 'Family film',
        room: 'Room 1',
        screeningTime: '15:00',
        endTime: '17:00',
        ticketPrice: 5.0,
        imagePath: 'assets/images/family.jpg',
      );

      expect(movie.isChildFriendly, true);
      expect(movie.isAdultOnly, false);
    });

    // Test 4: Check adult-only age ratings
    test('identifies adult-only movies', () {
      const movie = Movie(
        id: 'adult-movie',
        title: 'Adult Movie',
        year: 2026,
        ageRating: '18',
        synopsis: 'Test description',
        room: 'Room 1',
        screeningTime: '20:00',
        endTime: '22:00',
        ticketPrice: 7.50,
        imagePath: 'assets/images/adult.jpg',
      );

      expect(movie.isAdultOnly, true);
      expect(movie.isChildFriendly, false);
    });
  });
}
