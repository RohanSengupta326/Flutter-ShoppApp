import 'package:flutter/material.dart';

class ProductEditingScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _ProductEditingScreenState createState() => _ProductEditingScreenState();
}

class _ProductEditingScreenState extends State<ProductEditingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DashBoard',
        ),
      ),
      body: Form(
        // for using a form
        child: ListView(
          // not unlimited fields so not .builder
          children: [
            TextFormField(
              // in TextFormField dont need to controller like in TextField cause Form handles those in the background
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'enter the title of the product',
              ),
              textInputAction: TextInputAction.next,
              // goes to next field while hit the submit button
            ),
          ],
        ),
      ),
    );
  }
}
