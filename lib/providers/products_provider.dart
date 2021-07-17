import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exceptions.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;//Just to avoid name clashes as http has a lot of methods
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [

  ];

  List<Product> get items {
    return [
      ..._items
    ]; //we do this so that we only return a copy of the original array, as arrays are reference types, if we return the original array, its content can
    //be modified from anywhere
  }

  List<Product> get favouriteitems {
    return _items.where((product) => product.isFavourite).toList();
  }

  Product findProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
Future<void> fetchAndSetProducts()async {
   const url = 'https://flutter-shop-ecb92-default-rtdb.firebaseio.com/products.json';
   try{
     final response = await http.get(url);
     print(json.decode(response.body));
     var receivedresponse = json.decode(response.body) as Map<String,dynamic>;
       if(receivedresponse==null){
        return;
      }
    List<Product> itemarr = [];
    receivedresponse.forEach((prodId, productInfo) { 
      var prod = Product(id: prodId, title: productInfo['title'], description: productInfo['description'], price: productInfo['price'],imageUrl: productInfo['imageUrl'],isFavourite: productInfo['isFavourite']);
      itemarr.add(prod);
    });
    _items = itemarr;
    notifyListeners();
   }
   catch (error){
     throw error;
   }
}
  Future<void> addProduct(Product product)async {
    // _items.add(item);
    const url = 'https://flutter-shop-ecb92-default-rtdb.firebaseio.com/products.json';
    try{
    var response = await http.post(url,body: json.encode({
      'title':product.title,
      'description':product.description,
      'imageUrl':product.imageUrl,
      'price':product.price,
      'isFavourite':product.isFavourite
    }));
    
      print(json.decode(response.body));
        final newProduct = Product(
      title: product.title,
      id:json.decode(response.body)['name'],//using same id in backend and frontend
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavourite: product.isFavourite
    );
    
    _items.add(newProduct);

    notifyListeners();
    }
    catch (error){
      throw error;
    }
    
      
   
    
  }
  Future<void> updateProduct(String id,Product newProduct)async{
    final prodIndex = _items.indexWhere((element) => element.id==id);
     final url = 'https://flutter-shop-ecb92-default-rtdb.firebaseio.com/products/$id.json';
    if(prodIndex>=0){
      await http.patch(url,body: json.encode({
        "title":newProduct.title,
        "price":newProduct.price,
        "description":newProduct.description,
        "imageUrl":newProduct.imageUrl
      }));
      _items[prodIndex]=newProduct;
    notifyListeners();
    }
    else{
      print('...no items found');
    }
    
  }

  Future<void> deleteProduct(String id)async{
    final url = 'https://flutter-shop-ecb92-default-rtdb.firebaseio.com/products/$id.json';
    var existingProdIndex = _items.indexWhere((element) => element.id==id);
    var existingProd = _items[existingProdIndex];
    _items.removeWhere((element) => element.id==id);
    var response = await http.delete(url);
    
      if(response.statusCode>=400){
          _items.insert(existingProdIndex, existingProd);
      // notifyListeners();
        //We are doing this because 'delete' in firebase does not by default consider 405 as an error like the other methods
        throw HttPExceptions('Could not delete product');//When we trhrow it manually like this catchError will be triggered
      }
      else{
      existingProd = null;

      }
    
   
    notifyListeners();
  }

  
}
