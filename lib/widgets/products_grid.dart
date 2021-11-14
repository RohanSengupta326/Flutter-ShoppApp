import 'package:flutter/material.dart';
import '../widgets/productitem.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class product_grid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    // of<> mentioning where do u wanna listen the changes from, here its from Products class
    // listens and goes where the provider is and checks, Products class is instanciated there, so it listens changes from that
    // class and rebuilds this widget ONLY
    final products = productData.items;
    // stores data from Products class from the items getter in the Products class
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          // with fixed amount of space taken per grid
          childAspectRatio: 2 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2),
      itemBuilder: (ctx, index) => ChangeNotifierProvider(
        // connecting provider to ProductItem cause thats the page we want to rebuild
        create: (c) => products[index],
        // as the isFavorite is in the list _items, so it has to check the changes from there
        child: ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
