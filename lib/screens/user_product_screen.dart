import 'package:flutter/material.dart';

import '../widgets/side_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_product';
  @override
  Widget build(BuildContext context) {
    final Products productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: SideDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_, i) {
            return Column(
              children: [
                UserProductItem(
                  productsData.items[i].title,
                  productsData.items[i].imageUrl,
                ),
                Divider()
              ],
            );
          },
          itemCount: productsData.items.length,
        ),
      ),
    );
  }
}
