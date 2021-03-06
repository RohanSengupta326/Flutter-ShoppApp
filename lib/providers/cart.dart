import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imgUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imgUrl,
  });
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

  void removeItem(String prodId) {
    _items.remove(prodId);
    // this prodId is a key of the map
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      // if quantitiy more than 1 then remove 1 item
      _items.update(
        productId,
        (existingval) => CartItem(
          id: existingval.id,
          title: existingval.title,
          price: existingval.price,
          quantity: existingval.quantity - 1,
          // minus 1 item
          imgUrl: existingval.imgUrl,
        ),
      );
    } else {
      _items.remove(productId);
      // if 1 item left then delete that too
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
