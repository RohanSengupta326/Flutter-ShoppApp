import 'package:flutter/material.dart';

import '../providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  final String token;
  final String userId;
  Order(this.token, this.userId);
  // for user log in authentication

  Future<void> fetchAndSetOrders() async {
    final urlori =
        "https://fluttershopapp-e18fe-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token";
    // users personal token sending to server to let server know user is logged in
    final url = Uri.parse(
      urlori,
    );
    final List<OrderItem> orderStore = [];
    final response = await http.get(url);

    final responseBody = json.decode(response.body);
    final Map<String, dynamic>? extractedData =
        responseBody == null ? null : responseBody as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }
    extractedData.forEach(
      (orderId, orderData) {
        orderStore.add(
          OrderItem(
            id: orderId,
            price: orderData['price'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                    imgUrl: item['imageUrl'],
                  ),
                )
                .toList(),
            datetime: DateTime.parse(
              orderData['datetime'],
            ),
          ),
        );
      },
    );
    _orders = orderStore.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final urlori =
        "https://fluttershopapp-e18fe-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token";
    final url = Uri.parse(
      urlori,
    );

    final response = await http.post(
      url,
      body: json.encode(
        {
          'price': total,
          'datetime': timeStamp.toIso8601String(),
          // toIso.. converts to string but which is easy to convert to date back again
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                    'imageUrl': e.imgUrl,
                  })
              .toList(),
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
        products: cartProducts,
        price: total,
        datetime: DateTime.now(),
        id: json.decode(response.body)['name'],
      ),
    );

    notifyListeners();
  }
}
