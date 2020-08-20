import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/side_drawer.dart';

import '../providers/order.dart' show Order;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: SideDrawer(),
      body: ordersData.orders.length < 1
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
