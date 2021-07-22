



import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/config/config.dart';
import 'package:shop_app/config/configLoader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exceptions.dart';

class Auth with ChangeNotifier{
  String token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

set authToken(String value) {
  token = value;
}
  bool get isAuth{
    //To check if user has token and is authenticated
    return tokenCheck!=null;
  }
  String get userid{
    return _userId;
  }

  String get tokenCheck{
    if(token!=null&&_expiryDate!=null&&_expiryDate.isAfter(DateTime.now())){
      return token;
    }
    return null;
  }

Future<void> _authenticateUser(email,password,reqType) async{
     var config = await  ConfigLoader(secretPath: "assets/config.json").load();
    final url = "https://identitytoolkit.googleapis.com/v1/accounts:$reqType?key="+config.firebaseKey;
  try{
    print('Here success');


    print(config.firebaseKey);
    final response = await http.post(url,body: json.encode({"email":email,"password":password,"returnSecureToken":true}));

    // print(json.decode(response.body));
    var respBody = json.decode(response.body);
    // print('ResponseBodY: $respBody');
    if(respBody["error"]!=null){
      // print('In custom error');
      throw HttPExceptions(respBody["error"]["message"]); //Throwing our own custom exception as in firebase some errors come with 200 status and are thus not caught in catch()
    }
    else{
      
        token = respBody["idToken"];
        print("here set values token: $token");
        _userId = respBody["localId"];
        _expiryDate = DateTime.now().add(Duration(seconds: int.parse(respBody["expiresIn"])));
        autoLogout();
        notifyListeners();

        //Writing Data to Device to Persist Login
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token':token,
          'userId':_userId,
          'expiryDate':_expiryDate.toIso8601String()
        });
        prefs.setString('userData', userData);
    }
  }
  catch(error){
    print('In generic error: $error');
    throw error;
  }
}
Future<void> signUpUser(email,password) async{
 print('In Sign UP');
      return _authenticateUser(email, password, 'signUp');

  
  }

  Future<void> signInUser(email,password) async{
    print('In Sign In');
      return _authenticateUser(email, password, 'signInWithPassword');
 
  }

  Future<bool> tryAutoLogin() async{
    print("Hereee in auto login: ");
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      print("Here in false");
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData'));
    var expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    print("Expiry Date: $expiryDate");
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    //If this test also passes then the expiry date is in the future
    token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> logoutUser()async {
    token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer!=null){
      _authTimer.cancel();
      _authTimer = null;
    }
  notifyListeners();
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
  }

  void autoLogout(){
    if(_authTimer!=null){
      _authTimer.cancel();
    }
    var timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds:timeToExpiry),logoutUser);
  }


}