import 'package:flutter/material.dart';
import '../widgets/productitem.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class product_grid extends StatelessWidget {
  final dynamic favorNah;

  product_grid(this.favorNah);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    // of<> mentioning where do u wanna listen the changes from, here its from Products class
    // listens and goes where the provider is and checks, Products class is instanciated there, so it listens changes from that
    // class and rebuilds this widget ONLY
    final products = favorNah ? productData.favorites : productData.items;
    // stores data from Products class from the items getter in the Products class
    // made a function favorites to show only items with favorites true
    return productData.items.isEmpty
        ? const Center(
            child: Text(
              'No Items to show!',
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                // with fixed amount of space taken per grid
                childAspectRatio: 2 / 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 2),
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              // connecting provider to ProductItem cause thats the page we want to rebuild
              value: products[index],
              //ChangeNotifierProvider cleans the old date so that data doesnt overflow
              /* create: (ctx)=> producuts[i] */
              //not using this cause when a lot of items it puts items in recyle list
              // as the isFavorite is in the list _items, so it has to check the changes from there
              child: ProductItem(),
            ),
            itemCount: products.length,
          );
  }
}
