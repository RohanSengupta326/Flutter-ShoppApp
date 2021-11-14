import 'package:flutter/material.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return ChangeNotifierProvider(
      // Connecting the provider
      create: (ctx) => Products(),
      // instance of the provider class = Products class
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
        },
      ),
    );
  }
}
