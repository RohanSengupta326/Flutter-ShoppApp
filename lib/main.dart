import 'package:flutter/material.dart';
import 'package:flutter_proj6shopapp/providers/cart.dart';
import 'package:flutter_proj6shopapp/screens/products_editing_screen.dart';
import '../screens/order_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import '../providers/order.dart';
import './screens/manage_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MultiProvider(
      // to use multiple providers
      providers: [
        ChangeNotifierProvider(
          // Connecting the provider
          create: (ctx) => Products(),
          // instance of the provider class = Products class
        ),
        // using create: when creating a new instance of a class and for existing object use .value

        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        )
      ],
      // both providers take this child
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'amazon lite',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
          appBarTheme: const AppBarTheme(
            color: Colors.deepPurple,
            elevation: 6,
          ),
        ).copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.yellow,
          ),
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          Order_screen.routeName: (ctx) => Order_screen(),
          ManageProductsScreen.routeName: (ctx) => ManageProductsScreen(),
          ProductEditingScreen.routeName: (ctx) => ProductEditingScreen(),
        },
      ),
    );
  }
}
