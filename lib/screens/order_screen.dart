import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/side_drawer.dart';

import '../providers/order.dart' show Order;
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 1),
    ).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Order>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context);
    ordersData.fetchAndSetOrders();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: SideDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ordersData.orders.length < 1
              ? Center(
                  child: Text('No Orders yet, try adding some.'),
                )
              : ListView.builder(
                  itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
                  itemCount: ordersData.orders.length,
                ),
    );
  }
}
