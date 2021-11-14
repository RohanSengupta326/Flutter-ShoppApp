import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    // <Product> as this time checking changes from Product class

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
          leading: IconButton(
            onPressed: () {
              product.toggleFavorite();
            },
            icon: Icon(
              product.favorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).colorScheme.secondary,
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
            ),
          ),
        ),
      ),
    );
  }
}
