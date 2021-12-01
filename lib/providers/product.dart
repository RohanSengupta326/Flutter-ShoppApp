import 'package:flutter/material.dart';
import 'package:flutter_proj6shopapp/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  Future<void> toggleFavorite(String id, String token) async {
    final urlori =
        "https://fluttershopapp-e18fe-default-rtdb.firebaseio.com/products/$id.json?auth=$token";
    final url = Uri.parse(
      urlori,
    );
    favorite = !favorite;
    notifyListeners();
    final response = await http.patch(
      url,
      body: json.encode(
        {
          'isFavorite': favorite,
        },
      ),
    );
    if (response.statusCode >= 400) {
      favorite = !favorite;
      notifyListeners();
      throw HttpException('Couldn\'t add/remove to/from favorites');
    }
  }
}
