import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    // <Product> as this time checking changes from Product class
    // listen false wont rebuild the whole page I use Consumer down below with the iconbutton cz I want that to rebuild only
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // just like listTile
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          // GridTileBar best used with footer
          title: Center(
            child: FittedBox(
              child: Text(
                product.title,
              ),
            ),
          ),
          leading: Consumer<Product>(
            // same as provider.of<Product>(context) but just for a particular widget, so this widget only gets rebuilt
            builder: (ctx, product, child) => IconButton(
              // child is used to store anything in this widget that I dont want to rebuild
              /* child: Text('change nothing!'), => this get stored in that child */
              onPressed: () {
                product.toggleFavorite();
              },
              icon: Icon(
                product.favorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItems(product.id, product.price, product.title);
              //adds items to favorite maps in Cart class
            },
            icon: const Icon(
              Icons.shopping_cart,
            ),
          ),
        ),
      ),
    );
  }
}
