import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';

import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

enum Filters {
  fav,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showfav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Amazon Lite',
        ),
        actions: <Widget>[
          PopupMenuButton(
            // 3 dot dropdown
            onSelected: (Filters selected) {
              setState(() {
                // using stateful widget not provider cause provider is used for appwide filters but here we only want to apply
                // the favorites filter only on this page
                if (selected == Filters.fav) {
                  showfav = true;
                } else {
                  showfav = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Show favorites'),
                value: Filters.fav,
                // takes integers
              ),
              const PopupMenuItem(
                child: Text('Show all'),
                value: Filters.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              // pull from cartData which is Cart class
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(
                  Icons.shopping_cart,
                ),
              ),
              value: cartData.items.length.toString(),
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: product_grid(showfav),
    );
  }
}
