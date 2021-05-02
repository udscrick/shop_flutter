import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_overview_screen/product_item.dart';

class ProductsGrid extends StatelessWidget {
  
  final bool _showFavourites;
  ProductsGrid(this._showFavourites);



  @override
  Widget build(BuildContext context) {
    final loadedProductsProvider = Provider.of<ProductsProvider>(context);
    final loadedProducts = _showFavourites?loadedProductsProvider.favouriteitems:loadedProductsProvider.items;
    return GridView.builder(
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (ctx)=>loadedProducts[i],
        value: loadedProducts[i],
              child: ProductItem(
          // id: loadedProducts[i].id,
          // imgUrl: loadedProducts[i].imageUrl,
          // title: loadedProducts[i].title,
          // isFavourite: loadedProducts[i].isFavourite
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
