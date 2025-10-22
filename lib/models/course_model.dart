class CourseModel {
  final int id;
  final String title;
  final String description;
  final String instructor;
  final String price;
  final String duration;
  final String category;
  final double rating;
  final bool isBestseller;
  final String thumbnail;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.price,
    required this.duration,
    required this.category,
    required this.rating,
    required this.isBestseller,
    required this.thumbnail,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      price: json['price'],
      duration: json['duration'],
      category: json['category'],
      rating: json['rating'].toDouble(),
      isBestseller: json['isBestseller'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'price': price,
      'duration': duration,
      'category': category,
      'rating': rating,
      'isBestseller': isBestseller,
      'thumbnail': thumbnail,
    };
  }
}
