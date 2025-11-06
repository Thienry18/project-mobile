class Course {
  final String images;
  final String title;
  final String duration;
  final String rating;
  final String price;
  final bool isBestseller;
  final int index;
  final String category;
  final String instructor;
  final String language;
  final String subtitle;

  const Course({
    required this.images,
    required this.title,
    required this.duration,
    required this.rating,
    required this.price,
    required this.isBestseller,
    required this.index,
    required this.category,
    required this.instructor,
    required this.language,
    required this.subtitle,
  });

  double get ratingNumber {
    final part = rating.split(' ').first;
    return double.tryParse(part) ?? 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'idx': index,
      'images': images,
      'title': title,
      'duration': duration,
      'rating_text': rating,
      'rating_number': ratingNumber,
      'price': price,
      'is_bestseller': isBestseller ? 1 : 0,
      'category': category,
      'instructor': instructor,
      'language': language,
      'subtitle': subtitle,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      images: map['images'] as String,
      title: map['title'] as String,
      duration: map['duration'] as String,
      rating: map['rating_text'] as String,
      price: map['price'] as String,
      isBestseller: (map['is_bestseller'] as int) == 1,
      index: map['idx'] as int,
      category: map['category'] as String,
      instructor: map['instructor'] as String,
      language: map['language'] as String,
      subtitle: map['subtitle'] as String,
    );
  }
}
