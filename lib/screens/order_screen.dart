import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/order.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class Order_screen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<Order_screen> createState() => _Order_screenState();
}

class _Order_screenState extends State<Order_screen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (_) async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Order>(context, listen: false).fetchAndSetOrders();
        setState(() {
          _isLoading = false;
        });
      },
    );
    super.initState();
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, index) => Orderitem(
                orderData.orders[index],
              ),
            ),
    );
  }
}
