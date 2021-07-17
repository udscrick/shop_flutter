
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart'
    show
        Cart; //Since from this file we only require the Cart Class, otherwise cart item name clash
import 'package:shop_app/providers/orders_provider.dart';
import '../widgets/cart_screen/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  var isLoaded = true;
  onOrderNowClick(cart,BuildContext context) async {
    isLoaded = false;
    await Provider.of<Orders>(context, listen: false)
        .addOrder(cart.items.values.toList(), cart.totalAmount);
        isLoaded = true;
    cart.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed:()=>(cart.totalAmount<=0||!isLoaded)?null: onOrderNowClick(cart,context),//Button is disabled automatically if value is null
                    child: Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child:isLoaded?  ListView.builder(
            itemCount: cart.cartItemTotal,
            itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                productid: cart.items.keys.toList()[i]),
          ):
    Center(child: CircularProgressIndicator())
          )

        ],
      ),
    );
  }
}
