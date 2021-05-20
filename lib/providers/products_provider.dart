import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 29.99,
        imageUrl:
            'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
        isFavourite: false),
    Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
        isFavourite: false),
    Product(
        id: 'p3',
        title: 'Yellow Scarf',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 19.99,
        imageUrl:
            'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
        isFavourite: false),
    Product(
        id: 'p4',
        title: 'A Pan',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
        isFavourite: false),
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

  void addProduct(Product product) {
    // _items.add(item);
    final newProduct = Product(
      title: product.title,
      id: DateTime.now().toString(),
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavourite: product.isFavourite
    );
    _items.add(newProduct);
    notifyListeners();
  }
  void updateProduct(String id,Product newProduct){
    final prodIndex = _items.indexWhere((element) => element.id==id);
    if(prodIndex>=0){
      _items[prodIndex]=newProduct;
    notifyListeners();
    }
    else{
      print('...no items found');
    }
    
  }

  void deleteProduct(String id){
    _items.removeWhere((element) => element.id==id);
    notifyListeners();
  }
}
