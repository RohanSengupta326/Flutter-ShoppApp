import 'package:flutter/material.dart';
import '../api/api_keys.dart';
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
  Future<void> toggleFavorite(String userId, String token) async {
    final urlori =
        "${ApiKeys.firebaseUrl}/userFavorites/$userId/$id.json?auth=$token";
    // creating new folder userFavorites in firebase to store favorites true/false for each user
    final url = Uri.parse(
      urlori,
    );
    favorite = !favorite;
    notifyListeners();
    /* final response = await http.patch( */
    // patch was to update data in the database
    final response = await http.put(
      // put is to replace data, putting fav true or false for that user
      url,
      body: json.encode(
        favorite,
      ),
    );
    if (response.statusCode >= 400) {
      favorite = !favorite;
      notifyListeners();
      throw HttpException('Couldn\'t add/remove to/from favorites');
    }
  }
}
