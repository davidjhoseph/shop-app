import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../providers/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orders;
  OrderItem(this.orders);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.orders.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('d MMMM y hh:mm').format(widget.orders.dateTime),
            ),
            trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          if (_expanded)
            Container(
              height: min(widget.orders.products.length * 20.0 + 50, 180),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView(
                children: widget.orders.products
                    .map(
                      (p) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              p.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${p.quantity} x \$${p.price}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
