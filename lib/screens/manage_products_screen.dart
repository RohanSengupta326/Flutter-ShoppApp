import 'package:flutter/material.dart';
import '../screens/products_editing_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/manage_products.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';

  Future<void> _refreshProds(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchOrSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final userProducts = Provider.of<Products>(context);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text(
            'Manage Products',
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ProductEditingScreen.routeName, arguments: '');
                // passing argument as '' cause its not taking null => then its causing problem to add product
                // in the products_editing_screen,
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          // pull to refresh 
          onRefresh: () => _refreshProds(context),
          // onRefresh takes a future
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemBuilder: (ctx, index) => Column(
                // this column to put the divider in between
                children: [
                  ManageProducts(
                    userProducts.items[index].id,
                    userProducts.items[index].title,
                    userProducts.items[index].imageUrl,
                  ),
                  const Divider(),
                ],
              ),
              itemCount: userProducts.items.length,
            ),
          ),
        ));
  }
}
