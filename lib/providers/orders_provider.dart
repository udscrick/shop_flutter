

import 'package:flutter/material.dart';
import 'package:shop_app/models/cartitem.dart';
import 'package:shop_app/models/orderitem.dart';


class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];

  List<OrderItem> get orders{
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems,double total){
    _orders.insert(0, OrderItem(id:DateTime.now().toString(),
    amount: total,
    dateTime: DateTime.now(),
    products: cartItems));
    notifyListeners();
  }
}