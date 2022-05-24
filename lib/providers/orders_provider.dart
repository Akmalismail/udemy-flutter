import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart_provider.dart';

class Order {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  Order({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
        'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/orders.json');

    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Order> loadedOrders = [];

      data.forEach(
        (orderId, orderData) {
          // print(json.decode(orderData['products']) as List<Cart>);
          loadedOrders.add(
            Order(
              id: orderId,
              amount: orderData['amount'],
              products: (json.decode(orderData['products']) as Iterable)
                  .map(
                    (cartItem) => Cart(
                      id: cartItem['id'],
                      price: cartItem['price'],
                      title: cartItem['title'],
                      quantity: cartItem['quantity'],
                    ),
                  )
                  .toList(),
              dateTime: DateTime.parse(orderData['dateTime']),
            ),
          );
        },
      );

      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<Cart> cartProducts, double total) async {
    final url = Uri.https(
        'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/orders.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': DateTime.now().toString(),
            'products': json.encode(
              cartProducts.map((e) => e.toJson()).toList(),
            ),
          },
        ),
      );

      final newOrder = Order(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      );

      _orders.insert(
        0,
        newOrder,
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
