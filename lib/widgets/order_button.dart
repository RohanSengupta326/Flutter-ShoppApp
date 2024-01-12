import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/order.dart';
import '../screens/order_screen.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          )
        : TextButton(
            onPressed: (widget.cartData.totalAmount <= 0 || _isLoading)
                ? null
                // null automatically disables the button if no function available
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<Order>(context, listen: false).addOrder(
                      widget.cartData.items.values.toList(),
                      // converting values in map to list
                      widget.cartData.totalAmount,
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    widget.cartData.clearCart();
                    Navigator.of(context).pushNamed(Order_screen.routeName);
                  },
            child: const Text(
              'order now !',
            ),
          );
  }
}
