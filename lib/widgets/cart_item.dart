import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class Cartitem extends StatelessWidget {
  final String prodid;
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imgUrl;

  Cartitem({
    required this.prodid,
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // slide to delete
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.only(
          right: 20,
        ),
        child:
            Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(prodid);
        // calling the function to delete items from map
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(
            6,
          ),
          child: ListTile(
            leading: Column(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                Container(
                  width: 30,
                  height: 11,
                  child: Text(
                    '\$$price',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(title),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
