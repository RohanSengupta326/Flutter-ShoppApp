import 'package:flutter/material.dart';

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    required this.id,
    required this.price,
    required this.products,
    required this.datetime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        products: cartProducts,
        price: total,
        datetime: DateTime.now(),
        id: DateTime.now().toString(),
      ),
    );
    notifyListeners();
  }
}
