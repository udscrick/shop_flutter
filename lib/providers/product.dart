// import 'package:flutter/cupertino.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exceptions.dart';//Just to avoid name clashes as http has a lot of methods

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite; //to check if a product is marked as favourite for each user

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    this.imageUrl,
    this.isFavourite});

     Future<void> markAsFavourite(String authToken,String userid)async{
       final url = 'https://flutter-shop-ecb92-default-rtdb.firebaseio.com/userFavourites/$userid/$id.json?auth=$authToken';
    isFavourite = !isFavourite;
    
    var response = await http.put(url,body: json.encode(isFavourite));
      if(response.statusCode>=400){
         isFavourite = !isFavourite;
     
        throw HttPExceptions('Could not update favourites');//When we trhrow it manually like this catchError will be triggered
      }
   
   
     notifyListeners();
  }

}