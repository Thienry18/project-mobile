class Course {
  final String imageUrl;
  final String title;
  final String duration;
  final String rating;
  final String price;
  final bool isBestseller;
  final int index;
  final String category; // Optional category field

  Course({
    required this.imageUrl,
    required this.title,
    required this.duration,
    required this.rating,
    required this.price,
    required this.isBestseller,
    required this.index,
    required this.category, // Initialize category in the constructor
  });
}
