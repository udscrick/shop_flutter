import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String productid;
  final String title;
  CartItem({this.id, this.price,this.productid, this.quantity, this.title});
  @override
  Widget build(BuildContext context) {
    
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,//right to left only
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(productid);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ), //Shown behind element when we start swiping
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
      confirmDismiss: (direction){
        //show dialog returns a future so we can directly return it
        return showDialog(context: context,
        builder: (ctx)=>AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to remove item from cart'),
          actions: [
            FlatButton(onPressed: (){
              Navigator.of(ctx).pop(false);
            }, child: Text('No')),
            FlatButton(onPressed: (){
              Navigator.of(ctx).pop(true);
            }, child: Text('Yes'))
          ],
        ));
      },
    );
  }
}
