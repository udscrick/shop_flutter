// import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

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

     void markAsFavourite(){
    isFavourite = !isFavourite;
     notifyListeners();
  }

}