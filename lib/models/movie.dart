class Movie {
  final String id,
      title,
      ageRating,
      synopsis,
      room,
      screeningTime,
      endTime,
      imagePath;
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

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      year: json['year'] as int,
      ageRating: json['ageRating'] as String,
      synopsis: json['synopsis'] as String,
      room: json['room'] as String,
      screeningTime: json['screeningTime'] as String,
      endTime: json['endTime'] as String,
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'ageRating': ageRating,
      'synopsis': synopsis,
      'room': room,
      'screeningTime': screeningTime,
      'endTime': endTime,
      'ticketPrice': ticketPrice,
      'imagePath': imagePath,
    };
  }

  // Format ticket price to two decimal places
  String get formattedPrice => '£${ticketPrice.toStringAsFixed(2)}';

  // Check if the movie is suitable for children
  bool get isChildFriendly => ageRating == 'U' || ageRating == 'PG';

  // Check if the movie is restricted to adults
  bool get isAdultOnly => ageRating == '18';
}
