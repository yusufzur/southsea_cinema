class Movie {
  final String id, title, ageRating, synopsis, room, screeningTime, endTime, imagePath;
  final int year;
  final double ticketPrice;

  const Movie({required this.id, required this.title, required this.year,
    required this.ageRating, required this.synopsis, required this.room,
    required this.screeningTime, required this.endTime,
    required this.ticketPrice, required this.imagePath});
}

