import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: null,
      price: 0,
      title: '',
      description: '',
      imageUrl: '',
      isFavourite: false);
var _isInit = true;
var _initValues = {
  'title':'',
  'description':'',
  'price':'',
  'imageUrl':''
};
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(_isInit){  
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId!=null)//If edit mode
      {
        _editedProduct = Provider.of<ProductsProvider>(context,listen: false).findProductById(productId);
      _initValues = {
        'title':_editedProduct.title,
        'description':_editedProduct.description,
        'price':_editedProduct.price.toString(),
        'imageUrl':''
      };
      _imageUrlController.text = _editedProduct.imageUrl;
      }
      
    }
    _isInit = false; //since did change dependencies will run multiple times
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (
          (!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) ||
         (!_imageUrlController.text.endsWith('.png') &&
          !_imageUrlController.text.endsWith('.jpeg') &&
          !_imageUrlController.text.endsWith('.jpg'))) {
        return;
      }
      setState(() {});
    }
  }

  void onSubmit() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if(_editedProduct.id!=null)//Editing
    {
Provider.of<ProductsProvider>(context,listen: false).updateProduct(_editedProduct.id,_editedProduct);
    }
    else{
        Provider.of<ProductsProvider>(context,listen: false).addProduct(_editedProduct);
    }
    
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                onSubmit();
              })
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          children: [
            TextFormField(
              initialValue: _initValues['title'],
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction
                  .next, //The submit button on the keyboard will go to next line and not submit form
              onSaved: (value) {
                _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a value';
                }
                return null; //Implies that input is correct and there is no error
              },
            ),
            TextFormField(
              initialValue: _initValues['price'],
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction
                  .next, //The submit button on the keyboard will go to next line and not submit form
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the price of the item';
                }
                if (double.tryParse(value) == null) {
                  //will check if it is possible to parse value into a number
                  return 'Please enter a valid number';
                }
                if (double.parse(value) <= 0) {
                  //we will arrive here only if the entered text is a number as parsing will be successful already
                  return 'Please enter a number greater than 0';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                     id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite);
              },
            ),
            TextFormField(
              initialValue: _initValues['description'],
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              keyboardType: TextInputType
                  .multiline, //Keyboard specifically suited for multiline

              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a description';
                }
                if (value.length < 10) {
                  return 'Description should be atleast 10 characters long';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite);
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 8, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: _imageUrlController.text.isEmpty
                      ? Text('Enter a URL')
                      : FittedBox(
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Expanded(
                  child: TextFormField(
                    
                    decoration: InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction
                        .done, //Since its the last input we want to submit form
                    controller:
                        _imageUrlController, //we need the value of this imput before the form is submitted in order to show preview
                    focusNode:
                        _imageUrlFocusNode, //when control loses focus, we will update ui with the preview
                    onFieldSubmitted: (_) => {onSubmit()},
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an imageUrl';
                      }
                      if (!value.startsWith('http') &&
                          !value.startsWith('https')) {
                        return 'Please enter a valid URL';
                      }
                      if (!value.endsWith('.png') &&
                          !value.endsWith('.jpeg') &&
                          !value.endsWith('.jpg')) {
                        return 'Please enter a valid image URL';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                           id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite);
                    },
                    onEditingComplete: () {
                      setState(
                          () {}); //forcing flutter to rerender the screen once imageurl is submitted
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
