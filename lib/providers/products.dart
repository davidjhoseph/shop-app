import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favoriteProducts {
    return _items.where((product) => product.isFavorite).toList();
  }

  List<Product> _cart = [];

  List<Product> get cartItems {
    return [..._cart];
  }

  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-shop-app-1346f.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final gottenProducts = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      gottenProducts.forEach((productId, productData) {
        loadedProducts.add(
          Product(
              description: productData['description'],
              id: productId,
              price: productData['price'],
              imageUrl: productData['imageUrl'],
              title: productData['title']),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) {
    const url = 'https://flutter-shop-app-1346f.firebaseio.com/products.json';
    return http
        .post(
      url,
      body: json.encode(
        {
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'isFavorite': product.isFavorite,
          'imageUrl': product.imageUrl,
        },
      ),
    )
        .then((response) {
      final newProduct = Product(
        description: product.description,
        id: json.decode(response.body)['name'],
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      );
      _items.add(newProduct);
      notifyListeners();
    });
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final url =
          'https://flutter-shop-app-1346f.firebaseio.com/products/$id.json';
      await http.patch(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl
          },
        ),
      );
      _items[index] = product;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    final url =
        'https://flutter-shop-app-1346f.firebaseio.com/products/$id.json';
    http.delete(url);
    notifyListeners();
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }
}
