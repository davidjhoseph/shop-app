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
  String token;
  String userId;
  Order(this._orders, {this.userId, this.token});
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double amount) async {
    final url =
        'https://flutter-shop-app-1346f.firebaseio.com/orders/$userId.json?auth=$token';
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

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-app-1346f.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    List<OrderItem> loadedOrders = [];
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          amount: orderData['amount'],
          id: orderId,
          products: (orderData['products'] as List<dynamic>)
              .map(
                (prod) => CartItem(
                  id: prod['id'],
                  title: prod['title'],
                  quantity: prod['quantity'],
                  price: prod['price'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(
            orderData['dateTime'],
          ),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
