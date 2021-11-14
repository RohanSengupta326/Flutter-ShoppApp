import 'package:flutter/material.dart';



class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool favorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.favorite = false,
  });

  // defining this function here cause connected the provider to the Product to check favorite or not
  void toggleFavorite() {
    favorite = !favorite;
    notifyListeners();
  }
}
