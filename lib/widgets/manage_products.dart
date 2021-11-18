import 'package:flutter/material.dart';

class ManageProducts extends StatelessWidget {
  final String title;
  final String imgUrl;
  ManageProducts(this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imgUrl,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit,
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
              ),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
      // NetWorkImage is not a widget, its a provider built in flutter to fetch image
    );
  }
}
