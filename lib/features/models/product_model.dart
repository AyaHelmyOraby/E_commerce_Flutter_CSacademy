class ProductModel {
  final int? id;
  final String title;
  final String description;
  final double price;
  final String image;
  bool isFavourite;
  bool addToCard;

  ProductModel({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.isFavourite = false,
    this.addToCard = false
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        image: json['image'] ?? '',
        isFavourite: false);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
