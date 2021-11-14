import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail-screen";

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;

    final loadedProduct =
        Provider.of<Products>(context, listen: false).searchById(productId);
    // listen: false => dont rebuild the widget
    // .searchById function created in Products class

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
        ),
      ),
    );
  }
}
