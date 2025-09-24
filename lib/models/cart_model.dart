import 'package:flutter/foundation.dart';
import 'laundry_service.dart';

class CartModel extends ChangeNotifier {
  final List<LaundryService> _items = [];

  List<LaundryService> get items => List.unmodifiable(_items);

  void add(LaundryService s) {
    _items.add(s);
    notifyListeners();
  }

  void remove(LaundryService s) {
    _items.remove(s);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get totalPrice => _items.fold(0, (sum, s) => sum + s.price);
}
