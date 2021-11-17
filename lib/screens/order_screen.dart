import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/order.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class Order_screen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Your Orders',
        ),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, index) => Orderitem(
          orderData.orders[index],
        ),
      ),
    );
  }
}
