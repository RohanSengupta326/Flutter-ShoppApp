import 'package:flutter/material.dart';
import './screens/splash_screen.dart';
import './screens/product_overview_screen.dart';
import './providers/cart.dart';
import 'screens/auth_screen.dart';
import './screens/products_editing_screen.dart';
import './screens/order_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';

import 'package:provider/provider.dart';
import './providers/products.dart';
import '../providers/order.dart';
import './screens/manage_products_screen.dart';
import './providers/auth.dart';
import './providers/order.dart';
import './helper/route_transition.dart';

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
          create: (ctx) => Auth(),
          // instance of the Auth class = Auths class
          // using create: when creating a new instance of a class and for existing object use .value
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          // changes from Auth will come, and need to reflect that in Products(different tokens)
          create: (ctx) => Products('', ''),
          update: (ctx, auth, prevProducts) => Products(
            // auth = pulling data from Auth Provider
            // prevProducts = before changes in auth products
            auth.token,
            // passing the token to products page / widget. 
            auth.userId,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (ctx) => Order('', ''),
          update: (_, auth, prevOrders) => Order(auth.token, auth.userId),
        ),
      ],
      // all 3 providers take this child
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ecommerce App',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            primaryColor: Colors.deepPurple,
            appBarTheme: const AppBarTheme(
              color: Colors.deepPurple,
              elevation: 6,
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(
                color: Colors.white,
              ),
            ),
          ).copyWith(
            colorScheme: theme.colorScheme.copyWith(
              secondary: Colors.yellow,
            ),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
              // added Fading animation when shifting from page to page
            }),
          ),
          home: authData.isAuth
              // if authenticated = token found then show products or else show authentication screen
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: authData.autoLogIn(),
                  // if this returns true, then consumer rebuilds and authData.isAuth will return true so it will auto log in
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            Order_screen.routeName: (ctx) => Order_screen(),
            ManageProductsScreen.routeName: (ctx) => ManageProductsScreen(),
            ProductEditingScreen.routeName: (ctx) => ProductEditingScreen(),
          },
        ),
      ),
    );
  }
}
