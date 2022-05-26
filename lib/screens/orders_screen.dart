import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    print('building orders');
    // commented to avoid infinite loop
    // final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        /**
         * if there is another state changing logic (such as presenting dialog) that rebuilds this widget,
         * the .fetchAndSetOrders() will run again eventhough orders were not affected whatsover
         * which is a waste of resources.
         *
         * Incase that happens, turn this widget to a [StatefulWidget] and then implement like this:
         * 
         * ```
         * class _OrdersScreenState extends State<OrdersScreen> {
         *  Future _ordersFuture;
         * 
         *  Future _obtainOrdersFuture() {
         *    return Provider.of<OrdersProvider>(context, listen: false).fetchAndSetOrders();
         *  }
         * 
         *  @override
         *  void initState() {
         *    _ordersFuture = _obtainOrdersFuture();
         *    super.initState();
         *  }
         * 
         *  @override
         *  Widget build(BuildContext context) {
         *    return Scaffold(
         *      ...
         *      body: FutureBuilder(
         *        ...
         *        future: _ordersFuture, <--- this ensures no new [Future] of .fetchAndSetOrders() are created.
         *        ...
         *      ),
         *      ...
         *    )
         *  }
         * }
         * ```
         */
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.error != null) {
            // ...
            // do error handling here
            return Center(
              child: Text('An error occured!'),
            );
          }

          return Consumer<Orders>(
            builder: (context, orderData, child) => ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, index) => OrderItem(
                orderData.orders[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
