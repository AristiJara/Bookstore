class Book{
  final String? id;
  final String title;
  final String author;
  final String? description;
  final double price;
  final int stock;
  final String genre;
  final String? image;

  Book({
    this.id,
    required this.title,
    required this.author,
    this.description,
    required this.price,
    required this.stock,
    required this.genre,
    this.image,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String?,
      price: json['price'] is String
        ? double.tryParse(json['price']) ?? 0.0
        : (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      genre: json['genre'] as String,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'stock': stock,
      'genre': genre,
      'image': image,
    };
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}
