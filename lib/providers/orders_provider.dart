import 'package:flutter/material.dart';
import 'package:shop_app/models/cartitem.dart';
import 'package:shop_app/models/orderitem.dart';
import 'package:http/http.dart'
    as http; //Just to avoid name clashes as http has a lot of methods
import 'dart:convert';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        'https://flutter-shop-ecb92-default-rtdb.firebaseio.com/orders.json';
    try {
      var response = await http.get(url);
      print(json.decode(response.body));
      var receivedresponse = json.decode(response.body) as Map<String, dynamic>;
      if(receivedresponse==null){
        return;
      }
      List<OrderItem> itemarr = [];
      receivedresponse.forEach((orderId, orderInfo) {
        var order = OrderItem(
            id: orderId,
            amount: orderInfo['amount'],
            dateTime: DateTime.parse(orderInfo['dateTime']),
            products: (orderInfo['products'] as List<dynamic>).map((e) => CartItem(id: e['id'], title: e['title'], price: e['price'], quantity: e['quantity'])).toList());
        itemarr.add(order);
      });
      _orders = itemarr.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
    }

    
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    const url =
        'https://flutter-shop-ecb92-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartItems
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price
                    })
                .toList()
          }));
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              dateTime: timestamp,
              products: cartItems));
      notifyListeners();
      print(json.decode(response.body));
      // var newOrder = OrderItem(id: response, amount: null, products: null, dateTime: null)
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
