import 'package:flutter/material.dart';
import '../screens/order_screen.dart';
import '../screens/product_overview_screen.dart';
import '../screens/manage_products_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text(
              'AmazonLite',
            ),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shop,
            ),
            title: const Text(
              'Shop',
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.payment,
            ),
            title: const Text(
              'Your Orders',
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(Order_screen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.edit,
            ),
            title: const Text(
              'Manage Products',
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageProductsScreen.routeName);
            },
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // so that before logging out the app drawer closes
              Navigator.of(context).pushReplacementNamed('/');
              // so that app goes back to main screen after logging out 
              Provider.of<Auth>(context, listen: false).logOut();
            },
            child: const Text('LogOut'),
            textColor: Colors.white,
            color: Colors.red,
            elevation: 6,
            padding: const EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }
}
