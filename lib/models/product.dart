import 'dart:convert';
import 'package:amazeshoppingapp/models/rating.dart';


class Product {
  final String name;
  final String description;
  final double quantity;
  final List<String> images;
  final String category;
  final double price;
  String? id;
  final List<Rating>? rating;

  // rating

  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'id': id,
      'rating': rating
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: (map['quantity'] != null) ? map['quantity'].toDouble() : 0.0,
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      price: (map['price'] != null) ? map['price'].toDouble() : 0.0,
      id: map['_id'],
      rating: map['ratings'] != null
          ? List<Rating>.from(map['ratings']?.map((e) => Rating.fromMap(e)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
