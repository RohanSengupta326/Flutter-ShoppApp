import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart';
import 'dart:math';

class Orderitem extends StatefulWidget {
  final OrderItem order;

  Orderitem(this.order);

  @override
  State<Orderitem> createState() => _OrderitemState();
}

class _OrderitemState extends State<Orderitem> {
  var _expanded = false;

  int calculateOrderListHeight() {
    int numberOfItems = widget.order.products.length;

    int maxItemTitleLength = 0;
    for (int i = 0; i < numberOfItems; i++) {
      maxItemTitleLength =
          max(maxItemTitleLength, widget.order.products[i].title.length);
    }

    return maxItemTitleLength;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('₹${widget.order.price}'),
            subtitle: Text(
              DateFormat('EEE, M/d/y').format(widget.order.datetime),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expanded
                ? (widget.order.products.length * calculateOrderListHeight())
                    .toDouble()
                : 5,
            child: ListView(
              children: widget.order.products
                  .map(
                    (prod) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          prod.title,
                          softWrap: true,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${prod.quantity}x₹${prod.price}',
                          softWrap: true,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
