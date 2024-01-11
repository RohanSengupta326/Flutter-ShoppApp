import 'package:flutter/material.dart';

import '../widgets/cart_item.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/order_button.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(
                15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount : '),
                  const Spacer(),
                  // puts text in one side and chip and button on another side
                  Chip(
                    // a rounded corner small space
                    label: FittedBox(
                        child: Text('₹${cartData.totalAmount.toString()}')),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  OrderButton(cartData: cartData),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => Cartitem(
                prodid: cartData.items.keys.toList()[index],
                // this is key, taking to delete the key and the value while sliding
                id: cartData.items.values.toList()[index].id,
                title: cartData.items.values.toList()[index].title,
                // like this cause items is a map
                imgUrl: cartData.items.values.toList()[index].imgUrl,
                price: cartData.items.values.toList()[index].price,
                quantity: cartData.items.values.toList()[index].quantity,
              ),
              itemCount: cartData.items.length,
            ),
          )
        ],
      ),
    );
  }
}
