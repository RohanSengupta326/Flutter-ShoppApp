import 'package:flutter/material.dart';
import '../screens/products_editing_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ManageProducts extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;
  ManageProducts(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final scaffoldSnack = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          // NetWorkImage is not a widget, its a provider built in flutter to fetch image
          imgUrl,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ProductEditingScreen.routeName, arguments: id);
              },
              icon: const Icon(
                Icons.edit,
              ),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteItem(id);
                } catch (error) {
                  scaffoldSnack.removeCurrentSnackBar();
                  scaffoldSnack.showSnackBar(
                    // using scaffoldSnack variable cause cant call scaffold.of(context) inside here due to some internal flutter
                    // causes
                    const SnackBar(
                      content: Text(
                        'Couldn\'t delete file ',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.delete,
              ),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
