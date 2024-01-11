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
      confirmDismiss: (direction) {
        // function takes the direction of swipe as an argument
        // to check if user really wanna delete
        return showDialog(
          // showDialog returns Future<bool> => future<bool> means it will return a bool later, confirmDismiss wants a bool
          // fortunately showDialog returns a bool
          context: context,
          builder: (ctx) => AlertDialog(
            // this is to design the dialog box i wanna show
            title: const Text(
              'Are you sure? ',
            ),
            content: const Text(
              'The item in the cart will be deleted!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    false,
                  );
                  // pop(false) means return bool false, which means dont delete
                },
                child: const Text(
                  'No',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    true,
                  );
                  // pop(true) return bool true, deletes the item
                },
                child: const Text(
                  'Yes',
                ),
              ),
            ],
          ),
        );
      },

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
                  child: FittedBox(
                    child: Text(
                      '₹$price',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
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
