import './product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/product.dart';
// for converting to json
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  // changeNotifier Mixin => to use a function to notify the listeners about the change
  // mixin are class inheritance lite
  List<Product> _items = [
    /* 
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
    ), */
  ];

  List<Product> get items {
    return [..._items];
    // this means copy of the main items
  }

  List<Product> get favorites {
    return _items.where((element) => element.favorite).toList();
  }

/* 
  Future<void> addProduct(Product productData) {
    // now we need to return a Future from this function, cant do it inside .then() cause thats a nested function and
    // actually returns nothing for the addProduct function, also cant return outside the anonymus function cause that
    // will return first then recieve the info from the server later, so we return the whole http.post which return a
    // future cause its inbuilt

    // add http requests in provider
    const urlori =
        "https://fluttershopapp-e18fe-default-rtdb.firebaseio.com/products.json";
    final url = Uri.parse(
      urlori,
    );
    // /products.json is a folder I want to create in the database
    return http
        .post(
      // post request , save the data to the server
      url,
      body: json.encode(
        // converts this map to json, comes from dart:convert package
        {
          'title': productData.title,
          'description': productData.description,
          'price': productData.price,
          'imageUrl': productData.imageUrl,
          'isFavorite': productData.favorite,
        },
      ),
    )
        .then(
      (response) {
        // http.post actually returns a Future<Response>, means it takes the response from the server but that takes some time
        //(thats called asynchronus code or async) but our code doesnt wait for it to fetch the Response(<response>) from the server, it continues, so to wait before
        //executing the later code we put it in the then, so that it takes the response first then execute the rest portion of
        //the code
        final newproduct = Product(
          id: json.decode(response.body)['name'],
          // decoding the response body from the server and its a map with a unique  id as the value with name key
          title: productData.title,
          description: productData.description,
          price: productData.price,
          imageUrl: productData.imageUrl,
        );
        // new values inserted in Product instance
        _items.add(newproduct);
        // added newproduct to list
        notifyListeners();
        // notifies the listeners that data is changed);
      },
    ).catchError(
      (error) {
        print(error);
        throw error;
        // so that we can get the error in the widet so we can show the user something
      },
    );
  }
 */

  Future<void> fetchOrSetProducts() async {
    const urlori =
        "https://fluttershopapp-e18fe-default-rtdb.firebaseio.com/products.json";
    final url = Uri.parse(
      urlori,
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // it actually returns a nested map, so thats why we are recieving the data like Map<String...> but not like Map<String, Map<>>
      // cause flutter doesnt understand that
      final List<Product> prods = [];
      extractedData.forEach(
        // for each key of the parent map
        (prodIdKey, prodData) {
          // prodIdKey is the key of the parent map, prodData is the child map
          prods.add(
            Product(
              id: prodIdKey,
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              title: prodData['title'],
              favorite: prodData['isFavorite'],
            ),
          );
        },
      );
      _items = prods;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // the same function now with async and await
  Future<void> addProduct(Product productData) async {
    const urlori =
        "https://fluttershopapp-e18fe-default-rtdb.firebaseio.com/products.json";
    final url = Uri.parse(
      urlori,
    );
    try {
      // runs if succeds
      final response = await http.post(
        // await actually hides all the .then() and does it in the back
        // post request , save the data to the server
        url,
        body: json.encode(
          // converts this map to json, comes from dart:convert package
          {
            'title': productData.title,
            'description': productData.description,
            'price': productData.price,
            'imageUrl': productData.imageUrl,
            'isFavorite': productData.favorite,
          },
        ),
      );
      // no need to put the code below inside .then() anymore as using await
      final newproduct = Product(
        id: json.decode(response.body)['name'],
        // decoding the response body from the server and its a map with a unique  id as the value with name key
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
    } catch (error) {
      // runs if fails try
      print(error);
      throw (error);
      // so that we can get the error in the widet so we can show the user something
    }
  }

  Future<void> editProduct(String id, Product newProd) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    // found the index of the product in the Items list
    if (prodIndex >= 0) {
      final urlori =
          "https://fluttershopapp-e18fe-default-rtdb.firebaseio.com/products/$id.json";
      final url = Uri.parse(
        urlori,
      );
      await http.patch(
        // to edit products in the server
        url,
        body: json.encode(
          {
            'description': newProd.description,
            'imageUrl': newProd.imageUrl,
            'price': newProd.price,
            'title': newProd.title,
          },
        ),
      );
      _items[prodIndex] = newProd;
      // change the old item with the edited item
    }
    notifyListeners();
  }

  Future<void> deleteItem(String Id) async {
    final urlori =
        "https://fluttershopapp-e18fe-default-rtdb.firebaseio.com/products/$Id.json";
    final url = Uri.parse(
      urlori,
    );
    final existingProdIndex = _items.indexWhere((element) => element.id == Id);
    Product? storedDeletedProd = _items[existingProdIndex];
    // Product? means field can be set to null later
    _items.removeAt(existingProdIndex);
    // removing from the list, not from memory = storedDeletedProduct still have the product, because if deletion from
    // server goes wrong i will insert the product in the list again at the same index
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // show some error to user
      _items[existingProdIndex] = storedDeletedProd;
      // error = deletion went wrong so putting back the product in the list as I still have the product stored in the memory
      // in the storedDeletedProduct vaiable
      notifyListeners();
      throw HttpException('Could not delete file !');
    }
    storedDeletedProd = null;
    // can set to null cause defined this var like Product?, else wouldnt be able to
  }

  Product searchById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
