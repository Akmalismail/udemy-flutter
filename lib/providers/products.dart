import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  String authToken;
  String userId;

  void update(String token, String id, List<Product> items) {
    authToken = token;
    _items = items;
    userId = id;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var url = Uri.https(
      'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/products.json',
      {
        'auth': authToken,
        ...filterByUser
            ? {
                'orderBy': '"creatorId"',
                'equalTo': '"$userId"',
              }
            : {}
      },
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if (data == null) {
        return;
      }

      url = Uri.https(
        'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/user-favorites/$userId.json',
        {'auth': authToken},
      );
      final favoriteResponse = await http.get(url);
      final favoriteData =
          json.decode(favoriteResponse.body) as Map<String, dynamic>;

      data.forEach(
        (productId, productData) {
          loadedProducts.add(
            Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              imageUrl: productData['imageUrl'],
              isFavorite: favoriteData == null
                  ? false
                  : favoriteData[productId] ?? false,
            ),
          );
        },
      );

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
      'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/products.json',
      {'auth': authToken},
    );

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex =
        _items.indexWhere((product) => product.id == newProduct.id);

    if (productIndex >= 0) {
      final url = Uri.https(
        'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products/$id.json',
        {'auth': authToken},
      );

      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );

      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) async {
    // optimistic UI update approach.
    final url = Uri.https(
      'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/products/$id.json',
      {'auth': authToken},
    );

    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];

    // optimistic ui update, delete first before http request.
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    // for .delete, errors go in .then block
    if (response.statusCode >= 400) {
      // rollback deletion if fail
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      // throw exception
      throw HttpException('Could not delete product.');
    }

    // clear reference so dart can remove it from memory
    existingProduct = null;
  }
}
