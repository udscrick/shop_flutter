import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {

  static const routeName = 'product-details';
  
  
  @override
  Widget build(BuildContext context) {
    
    final prodId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context,listen: false).findProductById(prodId); //Here listen is set to false as we do not want this widget also to rerender
    //whenever the products array is modified in the provider
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}