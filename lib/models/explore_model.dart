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
      images: map['images'],
      title: map['title'],
      duration: map['duration'],
      rating: (map['rating_text'] ?? '${map['rating_number']}') as String,
      price: map['price'],
      isBestseller: (map['is_bestseller'] == 1),
      index: map['idx'],
      category: map['category'],
      instructor: map['instructor'],
      language: map['language'],
      subtitle: map['subtitle'],
    );
  }
}
