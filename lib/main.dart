import 'package:flutter/material.dart';
import '../screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
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
    );
  }
}
