import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imgUrl;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity,
      required this.imgUrl,});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );
    return total;
  }

  void addItems(String id, double price, String title, String imgUrl) {
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
          imgUrl: existing.imgUrl,
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
          imgUrl: imgUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String prodId){
    _items.remove(prodId);
    // this prodId is a key of the map
    notifyListeners();
  }

  void clearCart(){
    _items = {};
    notifyListeners();
  }
}
