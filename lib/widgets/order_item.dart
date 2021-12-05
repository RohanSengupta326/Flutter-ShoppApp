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
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.price}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.order.datetime),
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
                ? min(widget.order.products.length * 20.0 + 10, 100)
                : 5,
            child: ListView(
              children: widget.order.products
                  .map(
                    (prod) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          prod.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${prod.quantity}x \$${prod.price}',
                          style: const TextStyle(
                            fontSize: 18,
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
