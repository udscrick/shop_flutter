import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import '../providers/products_provider.dart';

import 'package:shop_app/widgets/product_overview_screen/products_grid.dart';

enum FilterOptions {
  Favourites, //Behind the scene they will get integer values....but for us it will improve readability
  All
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();


}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavourites = false;
  var isFirstCall  =true;
  var isLoaded = false;

  @override
    void initState() {
      // TODO: implement initState
      // Provider.of<ProductsProvider>(context,listen: false).fetchAndSetProducts(); //Option 1

      //Option 2
      // Future.delayed(Duration.zero).then((value){
      //   Provider.of<ProductsProvider>(context).fetchAndSetProducts();
      // });
      super.initState();
    }

//Option 3
    @override
      void didChangeDependencies() {
        // TODO: implement didChangeDependencies
        if(isFirstCall){
          print('here');
          Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((value){
            isLoaded = true;
          });
        }
        isFirstCall = false;
        super.didChangeDependencies();
      }

  @override
  Widget build(BuildContext context) {
    //  final productsData =  Provider.of<ProductsProvider>(context);
    //  final loadedProducts = productsData.items;//Can be used only when parent has provided a provider
    //  final cartprovider = Provider.of<Cart>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions selected) {
                setState(() {
                  if (selected == FilterOptions.Favourites) {
                    _showFavourites = true;
                  } else {
                    _showFavourites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Only Favourites'),
                        value: FilterOptions.Favourites),
                    PopupMenuItem(
                        child: Text('All Items'), value: FilterOptions.All)
                  ]),
              Consumer<Cart>(
              builder: (_, cartData, ch) => Badge(
                  child: ch,
                  value: cartData.cartItemTotal.toString()),
                  child: IconButton(
                      icon: Icon(Icons.shopping_cart), 
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      }),
                  )
        ],
      ),
      drawer: AppDrawer(),
      body:isLoaded? ProductsGrid(_showFavourites):Center(child: CircularProgressIndicator(),),
    );
  }
}
