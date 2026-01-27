class Product {
  final String id;
  final String name;
  final String brand;
  final String imageUrl;
  final double rating;
  final List<String> ingredients;
  final String description;
  final String? category;
  final String? price;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.rating,
    required this.ingredients,
    required this.description,
    this.category,
    this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      imageUrl: json['image_url'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ingredients: (json['ingredients'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      description: json['description'] as String? ?? '',
      category: json['category'] as String?,
      price: json['price'] as String?,
    );
  }

  factory Product.fromApiJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] ?? 0).toString(),
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      imageUrl: json['image_link'] ?? 'https://picsum.photos/seed/${json['id']}/400/400',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ingredients: (json['tag_list'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      description: json['description'] ?? '',
      category: json['category'] ?? json['product_type'],
      price: json['price']?.toString() ?? json['price_sign']?.toString(),
    );
  }
} 