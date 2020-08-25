import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.amount,
    @required this.id,
    @required this.products,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double amount) async {
    const url = 'https://flutter-shop-app-1346f.firebaseio.com/orders.json';
    final initialDate = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': amount,
          'dateTime': initialDate.toIso8601String(),
          'products': cartProducts
              .map(
                (cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity
                },
              )
              .toList()
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        amount: amount,
        id: json.decode(response.body)['name'],
        products: cartProducts,
        dateTime: initialDate,
      ),
    );
    notifyListeners();
  }
}
