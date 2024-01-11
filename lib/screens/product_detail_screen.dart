import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context)!.settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).searchById(productId);
    return Scaffold(
      /*appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: */
      body: CustomScrollView(
        // to add animation to scrolling
        slivers: <Widget>[
          // scrollable spaces are slivers
          SliverAppBar(
            // animated appbar, if scroll down appbar appears and image gets shorter and then vanishes
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // appbar effect mentioned above
              background: Hero(
                // image effect mentioned above
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            // normal page
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Text(
                  '₹${loadedProduct.price}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Text(
                    loadedProduct.title,
                    softWrap: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                const SizedBox(
                  // to actullay make the page scrollable to show the effect
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
