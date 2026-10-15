import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/home_view.dart';

void main() {
  testWidgets('Southsea Cinema opens with movies', (tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    // Check homepage and app title
    expect(find.byType(HomeView), findsOneWidget);
    expect(find.text(appTitle), findsOneWidget);

    // Check first movie and booking button
    expect(find.text('Eyes Wide Shut'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsWidgets);

    // Scroll to check the second movie
    await tester.scrollUntilVisible(
      find.text('The Grand Budapest Hotel'),
      250.0,
    );

    expect(find.text('The Grand Budapest Hotel'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsWidgets);
  });
}