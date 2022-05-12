import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Consumer<CartProvider>(
                    builder: (_, cartItem, __) => Chip(
                      label: Text(
                        '\$${cartItem.totalAmount}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {
                      Provider.of<OrdersProvider>(
                        context,
                        listen: false,
                      ).addOrder(
                        cartProvider.items.values.toList(),
                        cartProvider.totalAmount,
                      );

                      cartProvider.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) => CartItem(
                cartProvider.items.values.toList()[index].id,
                cartProvider.items.keys.toList()[index],
                cartProvider.items.values.toList()[index].title,
                cartProvider.items.values.toList()[index].price,
                cartProvider.items.values.toList()[index].quantity,
              ),
            ),
          )
        ],
      ),
    );
  }
}
