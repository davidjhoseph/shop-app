import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/order.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          cart.itemsCount > 1
              ? Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Chip(
                          label: Text(
                            '\$${cart.cartTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1
                                    .color),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        OrderButton(cart: cart),
                      ],
                    ),
                  ),
                )
              : Text('Sorry There is no Item in the Cart, try adding some!'),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                return CartItem(
                  id: cart.items.values.toList()[i].id,
                  title: cart.items.values.toList()[i].title,
                  quantity: cart.items.values.toList()[i].quantity,
                  price: cart.items.values.toList()[i].price,
                  productId: cart.items.keys.toList()[i],
                );
              },
              itemCount: cart.itemsCount,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        setState(() {
          _isLoading = true;
        });
        Provider.of<Order>(context, listen: false)
            .addOrder(
          widget.cart.items.values.toList(),
          widget.cart.cartTotal,
        )
            .then((_) {
          setState(() {
            _isLoading = false;
          });
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Order has been Placed'),
              duration: Duration(seconds: 2),
            ),
          );
          widget.cart.clear();
        });
      },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Order Now',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}
