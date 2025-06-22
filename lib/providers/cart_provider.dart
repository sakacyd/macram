import 'package:flutter/foundation.dart';
import 'package:macram/models/cart_item.dart';
import 'package:macram/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get total => _items.fold(
        0,
        (sum, item) => sum + item.total,
      );

  void addItem(CartItem newItem) {
    final index = items.indexWhere(
      (item) => item.product.id == newItem.product.id && item.flavor == newItem.flavor
    );
    if (index >= 0) {
      items[index].quantity += newItem.quantity;
    } else {
      items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    final index = items.indexWhere(
      (item) => item.product.id == cartItem.product.id && item.flavor == cartItem.flavor
    );
    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}