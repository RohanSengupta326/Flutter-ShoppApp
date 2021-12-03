import 'package:flutter/material.dart';
import '../screens/products_editing_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/manage_products.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';

  Future<void> _refreshProds(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchOrSetProducts(true);
    // sending true to fetchOrSetProducts cause this page only shows creatorProduct not all product
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _refreshProds(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    // pull to refresh
                    onRefresh: () => _refreshProds(context),
                    // onRefresh takes a future
                    child: Consumer<Products>(
                      // only rebuild the needed function else it will go into a infinite loop, cause we are already using
                      // future builder and all above
                      builder: (ctx, userProducts, _) => Padding(
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
                    ),
                  ),
      ),
    );
  }
}
