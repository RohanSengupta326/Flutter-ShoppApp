import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffoldSnack = Scaffold.of(context);
    final product = Provider.of<Product>(context, listen: false);
    // <Product> as this time checking changes from Product class
    // listen false wont rebuild the whole page I use Consumer down below with the iconbutton cz I want that to rebuild only
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
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
          child: Hero(
            // click an image, it will expand to product detail screen
            // also add the Hero widget to the widget on the page where you wanna expand the image to
            tag: product.id,
            // give the id of the product
            child: FadeInImage(
              // when image loads it shows an icon, when it completes loading the actual image comes in place of the placdeholder img
              placeholder: const AssetImage(
                'assets/images/waiting.jpeg',
              ),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          // GridTileBar best used with footer
          title: LayoutBuilder(
            builder: (buildContext, boxConstraints) {
              return Center(
                child: Text(
                  product.title.length < boxConstraints.maxWidth
                      ? product.title
                      : '${product.title.substring(
                          0,
                          (boxConstraints.maxWidth - 5).toInt(),
                        )}...',
                ),
              );
            },
          ),
          leading: Consumer<Product>(
            // same as provider.of<Product>(context) but just for a particular widget, so this widget only gets rebuilt
            builder: (ctx, prod, child) => IconButton(
              // product is to get all methods from Product class
              // child is used to store anything in this widget that I dont want to rebuild
              /* child: Text('change nothing!'), => this get stored in that child */
              onPressed: () async {
                try {
                  await prod.toggleFavorite(
                    auth.userId,
                    // sending userId to create new userFavorites folder to
                    auth.token,
                    // sending token to toggle favorite , to let server know user is logged in and using toggleFavorite func
                  );
                } catch (error) {
                  scaffoldSnack.removeCurrentSnackBar();
                  scaffoldSnack.showSnackBar(
                    // using scaffoldSnack variable cause cant call scaffold.of(context) inside here due to some internal flutter
                    // causes
                    const SnackBar(
                      duration: Duration(seconds: 4),
                      content: Text(
                        'Couldn\'t add/remove  to/from favorites',
                      ),
                    ),
                  );
                }
              },
              icon: Icon(
                prod.favorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItems(
                  product.id, product.price, product.title, product.imageUrl);
              //adds items to favorite maps in Cart class
              Scaffold.of(context).removeCurrentSnackBar();
              // before showing a snackbar , remove previous snakcbar first
              Scaffold.of(context).showSnackBar(
                // to show msg down in the screen that item was added

                SnackBar(
                  content: const Text(
                    'Added to cart Successfully!',
                  ),
                  duration: const Duration(seconds: 4),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(
                          // remove item from cart
                          product.id,
                        );
                      }),
                ),
              );
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
