import './product.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  // changeNotifier Mixin => to use a function to notify the listeners about the change
  // mixin are class inheritance lite
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
    // this means copy of the main items
  }

  List<Product> get favorites {
    return _items.where((element) => element.favorite).toList();
  }

  void addProduct(Product productData) {
    final newproduct = Product(
      id: DateTime.now().toString(),
      title: productData.title,
      description: productData.description,
      price: productData.price,
      imageUrl: productData.imageUrl,
    );
    // new values inserted in Product instance
    _items.add(newproduct);
    // added newproduct to list
    notifyListeners();
    // notifies the listeners that data is changed
  }

  void editProduct(String Id, Product newProd) {
    final prodIndex = _items.indexWhere((element) => element.id == Id);
    // found the index of the product in the Items list
    if (prodIndex >= 0) {
      _items[prodIndex] = newProd;
      // change the old item with the edited item
    }
    notifyListeners();
  }

  void deleteItem(String Id) {
    _items.removeWhere((element) => element.id == Id);
    notifyListeners();
  }

  Product searchById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
