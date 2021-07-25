import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../screens/orders_screen.dart';
import '../../screens/user_products_screen.dart';
import '../../helpers/custom_route.dart';

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
            // Navigator.of(context).pushReplacementNamed(OrdersScreen.routename);
            Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx)=>OrdersScreen()));
          },
        ),
         Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Manage Products'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
          },
          
        ),
          Divider(),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: (){
            // Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context,listen: false).logoutUser();
          }
        ),
      ],)
      
      ,
    );
  }
}