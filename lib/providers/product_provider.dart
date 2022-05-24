import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductProvider({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavorite(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;

    _setFavorite(!isFavorite);

    final url = Uri.https(
        'flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products/$id.json');

    /**
     * Flutter only catches errors for GET and POST requests.
     * For PUT, PATCH, and DELETE, errors will still be forwarded to .then blocks.
     * 
     * For network errors though, will always be caught.
     */
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );

      if (response.statusCode >= 400) {
        _setFavorite(oldStatus);
        throw HttpException('Could not favorite product.');
      }
    } catch (error) {
      _setFavorite(oldStatus);
      throw HttpException('Could not favorite product.');
    }
  }
}
