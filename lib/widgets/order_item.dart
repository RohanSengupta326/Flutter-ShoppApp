import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart';

class Orderitem extends StatelessWidget {
  final OrderItem order;

  Orderitem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${order.price}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(order.datetime),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.expand_more),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
