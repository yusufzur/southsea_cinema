import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

void main() {
  testWidgets('Southsea Cinema opens with movies', (tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeView), findsOneWidget);
    expect(find.text(appTitle), findsOneWidget);

    expect(find.text('Eyes Wide Shut'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('The Grand Budapest Hotel'),
      250.0,
    );

    expect(find.text('The Grand Budapest Hotel'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsWidgets);
  });

  // Test navigation from homepage to movie listing
  testWidgets('BOOK NOW opens the selected movie listing', (tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    // Tap the first movie's booking button
    final bookingButton = find.text('BOOK NOW').first;

    await tester.ensureVisible(bookingButton);
    await tester.tap(bookingButton);
    await tester.pumpAndSettle();

    // Verify navigation and movie details
    expect(find.byType(MovieListing), findsOneWidget);

    expect(
      find.text('EYES WIDE SHUT (1999) (18)'),
      findsOneWidget,
    );

    expect(find.text('Adult (£7.50)'), findsOneWidget);
    expect(find.text('ADD TO ORDER'), findsOneWidget);
  });
}
