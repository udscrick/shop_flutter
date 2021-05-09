import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductItem extends StatelessWidget {
  // final String imgUrl;
  // final String id;
  // final String title;
  // final bool isFavourite;
  // ProductItem({this.id, this.title, this.imgUrl,this.isFavourite});

  @override
  Widget build(BuildContext context) {
    final productinfo = Provider.of<Product>(context,
        listen:
            false); //listen is set to false as we dont want the entire widget to rebuild but only the part inside consumer
    final cartprovider = Provider.of<Cart>(context,
        listen:
            false); //We dont need to rerender the product item whenever the cart changes, so listen is false
    print("Product Item rebuilds");
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed('product-details', arguments: productinfo.id);
          },
          child: Image.network(
            productinfo.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Provider.of<Product>(context, listen: false)
                      .markAsFavourite();
                },
                color: productinfo.isFavourite
                    ? Theme.of(context).accentColor
                    : Colors.white),
          ),
          title: Text(
            productinfo.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cartprovider.addItem(
                  productinfo.id, productinfo.price, productinfo.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Item Added to Cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(label: 'UNDO', onPressed: (){
                    cartprovider.undoAdd(productinfo.id);
                  }),
                  ));
            },
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
