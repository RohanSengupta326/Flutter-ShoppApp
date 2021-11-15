import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItems(String id, double price, String title) {
    if (_items.containsKey(id)) {
      // if item already present
      _items.update(
        // updates map
        id,
        (existing) => CartItem(
          // exisiting are the prev values
          id: existing.id,
          title: existing.title,
          price: existing.price,
          quantity: existing.quantity + 1,
          // keeping all value same but updating quantity if same item is added to cart
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        // id is key
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
