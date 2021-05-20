import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import '../../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(title: Text('Hello'),
        automaticallyImplyLeading: false,),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Orders'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routename);
          },
        ),
         Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Manage Products'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
          },
        )
      ],)
      
      ,
    );
  }
}