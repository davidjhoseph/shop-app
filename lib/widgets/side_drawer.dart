import 'package:flutter/material.dart';
import '../screens/user_product_screen.dart';
import '../screens/order_screen.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            AppBar(
              title: Text('Your Menu'),
              automaticallyImplyLeading: false,
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text('My Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrderScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}
