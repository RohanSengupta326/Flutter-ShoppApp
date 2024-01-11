import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';

import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

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
  bool _isInit = true;
  bool _isLoading = false;

  // HACK FOR CALLING PROVIDER IN INIT STATE
  /* 
  @override
  void initState() {
    // not good to create http requests here so doing that in provider Products
    Future.delayed(Duration.zero).then(
      (value) {
        Provider.of<Products>(context).fetchOrSetProducts();
        // using context but initState is running before even creating any class, so cant access context, so put in Future
        // but if called listen:false then it would have worked without Future.delayed
      },
    );
    super.initState();
  } */

  // PROPER WAY FOR CALLING PROVIDER BEFORE CODE EXECUTION
  @override
  void didChangeDependencies() {
    // it actually runs after creating classes but before running build function so can call provider here
    if (_isInit) {
      // using _isInit so that after loading page it just fetch the data once no every time its getting rebuilt
      setState(
        () {
          _isLoading = true;
        },
      );
      Provider.of<Products>(context).fetchOrSetProducts().then(
        (_) {
          // using then cause inside didChangeDependencies we cant use async and await
          setState(
            () {
              _isLoading = false;
            },
          );
        },
      );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Ecommerce App',
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
          : product_grid(showfav),
    );
  }
}
