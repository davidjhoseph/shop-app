import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/order_screen.dart';

import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/order.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        // ChangeNotifierProxyProvider(create: null, update: null)
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products([]),
          update: (ctx, auth, previousProducts) => Products(
              previousProducts.items == null ? [] : previousProducts.items,
              authToken: auth.token),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (ctx) => Order([]),
          update: (ctx, auth, previousOrders) => Order(
              previousOrders != null ? previousOrders.orders : [],
              token: auth.token),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
