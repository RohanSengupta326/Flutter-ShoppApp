import 'package:flutter/material.dart';
import '../screens/order_screen.dart';
import '../widgets/cart_item.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/order.dart';

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
                    label: FittedBox(
                        child: Text('\$${cartData.totalAmount.toString()}')),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Order>(context, listen: false).addOrder(
                        cartData.items.values.toList(),
                        // converting items in map to list
                        cartData.totalAmount,
                      );
                      cartData.clearCart();
                      Navigator.of(context).pushNamed(Order_screen.routeName);
                    },
                    child: const Text(
                      'order now !',
                    ),
                  ),
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
