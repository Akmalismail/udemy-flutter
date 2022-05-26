import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }
}
