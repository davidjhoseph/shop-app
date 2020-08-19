import 'package:flutter/foundation.dart';

import './product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get cartTotal {
    var cartTotal = 0.0;
    _items.forEach((key, cartItem) {
      cartTotal += cartItem.price * cartItem.quantity;
    });
    return cartTotal;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingProduct) => CartItem(
          id: existingProduct.id,
          price: existingProduct.price,
          title: existingProduct.title,
          quantity: existingProduct.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: DateTime.now().toString(),
          price: product.price,
          quantity: 1,
          title: product.title,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
