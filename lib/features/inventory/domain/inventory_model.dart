import 'package:flutter/material.dart';

enum ProductStatus {
  inStock,
  lowStock,
  outOfStock,
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final int minStockLevel;
  final ProductStatus status;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.minStockLevel = 5,
    this.status = ProductStatus.inStock,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    int? minStockLevel,
    ProductStatus? status,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      status: status ?? this.status,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      minStockLevel: json['minStockLevel'] ?? 5,
      status: ProductStatus.values.firstWhere(
          (e) => e.toString() == 'ProductStatus.' + json['status']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'minStockLevel': minStockLevel,
        'status': status.toString().split('.').last,
      };
}
