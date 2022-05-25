import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

import 'product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _items = [];
  // var _showFavoritesOnly = false;

  List<ProductProvider> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((product) => product.isFavorite).toList();
    // }

    return [..._items];
  }

  List<ProductProvider> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  ProductProvider findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json');

    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductProvider> loadedProducts = [];

      if (data != null) {
        data.forEach(
          (productId, productData) {
            loadedProducts.add(
              ProductProvider(
                id: productId,
                title: productData['title'],
                description: productData['description'],
                price: productData['price'],
                imageUrl: productData['imageUrl'],
                isFavorite: productData['isFavorite'],
              ),
            );
          },
        );
      }

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(ProductProvider product) async {
    final url = Uri.https(
        'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      final newProduct = ProductProvider(
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

  Future<void> updateProduct(String id, ProductProvider newProduct) async {
    final productIndex =
        _items.indexWhere((product) => product.id == newProduct.id);

    if (productIndex >= 0) {
      final url = Uri.https(
          'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/products/$id.json');
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
        '/products/$id.json');
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
