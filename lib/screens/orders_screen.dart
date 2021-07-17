import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart' show Orders;
import 'package:shop_app/widgets/app_drawer/app_drawer.dart';
import 'package:shop_app/widgets/orders_screen/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routename = 'orders';
 
  // var firstCall = true;
  // var isLoaded = false;
  // var futureval;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //ALternative to consumer to prevent infinite loop
  //   futureval = Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
  //   super.initState();
  // }

  // @override
  //   void didChangeDependencies() {
  //     // TODO: implement didChangeDependencies
  //     // if(firstCall){
  //     //   Provider.of<Orders>(context).fetchAndSetOrders().then((value){
  //     //     isLoaded = true;
  //     //   });
  //     // }
  //     // firstCall = false;
      
  //     super.didChangeDependencies();
  //   }
    @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders'),),
      drawer: AppDrawer(),
      body: FutureBuilder(future: Provider.of<Orders>(context,listen: false).fetchAndSetOrders() , builder: (ctx,dataSnapshot){
        if(dataSnapshot.connectionState==ConnectionState.waiting){
          print('Here waiting');
          return Center(child: CircularProgressIndicator());
        }
        else{
          print('Here not waiting');
          if(dataSnapshot.error!=null){
            //Handle errors
          }
          return Consumer<Orders>(builder: (ctx,orderData,child)=>ListView.builder(itemCount: orderData.orders.length,
      itemBuilder: (ctx,i)=>OrderItem(orderData.orders[i])
          )); 
        }
      },
      )
      );
    
  }
}