class Movie {
  final String id, title, ageRating, synopsis, room, screeningTime, endTime, imagePath;
  final int year;
  final double ticketPrice;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.ageRating,
    required this.synopsis,
    required this.room,
    required this.screeningTime,
    required this.endTime,
    required this.ticketPrice,
    required this.imagePath,
  });

  // Format ticket price to two decimal places
  String get formattedPrice => '£${ticketPrice.toStringAsFixed(2)}';

  // Check if the movie is suitable for children
  bool get isChildFriendly => ageRating == 'U' || ageRating == 'PG';

  // Check if the movie is restricted to adults
  bool get isAdultOnly => ageRating == '18';
}