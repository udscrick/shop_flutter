import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/app_drawer/app_drawer.dart';
import '../widgets/user_products/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/myproducts';

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var isLoaded = false;
  Future<void> _onPageRefresh(BuildContext context)async{
    await Provider.of<ProductsProvider>(context,listen: false).fetchAndSetProducts(type:'user');
  }
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ProductsProvider>(context,listen: false).fetchAndSetProducts(type:'user').then((_){
      isLoaded = true;
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('My Products'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      body:isLoaded? RefreshIndicator(
        onRefresh:()=>_onPageRefresh(context) ,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(children: [
              UserProductItem(
                  
                  productsData.items[i].title, productsData.items[i].imageUrl,productsData.items[i].id),
              Divider()
            ]),
          ),
        ),
      ):Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
