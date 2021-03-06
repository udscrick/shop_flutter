import 'package:flutter/material.dart';
import 'package:shop_app/models/cartitem.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productid, double price, String title) {
    if (_items.containsKey(productid)) {
      //Only change qty
      _items.update(
          productid,
          (existingcarditem) => CartItem(
              id: existingcarditem.id,
              price: existingcarditem.price,
              title: existingcarditem.title,
              quantity: existingcarditem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productid,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              title: title,
              quantity: 1));
    }
    notifyListeners();
  }

  int get cartItemTotal {
    return _items.length;
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(id) {
    _items.remove(id);
    notifyListeners();
  }

  void undoAdd(String productid) {
    if (!_items.containsKey(productid)) {
      return;
    }
    if (_items[productid].quantity > 1) {
      _items.update(
        productid,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            quantity: value.quantity - 1)
      );
    }
    else{
      _items.remove(productid);
    }
    notifyListeners();
  }
}
