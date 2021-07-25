import 'package:flutter/material.dart';

//THis is if we want to apply route transitions to a particular route
class CustomRoute<T> extends MaterialPageRoute<T>{
  CustomRoute({WidgetBuilder builder,RouteSettings settings}) :super(builder: builder,settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    if(settings.name=='/'){
      //If this is the first route in the app then simply return the child without animation
      return child;
    }
    return FadeTransition(opacity: animation,child: child,);

  }

}

//THis is if we want to apply route transitions to all routes via the main dart file
class CustomPageTransitionBuilder extends PageTransitionsBuilder{

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation, Animation<double> secondaryAnimation, 
    Widget child) {
    // TODO: implement buildTransitions
    if(route.settings.name=='/'){
      //If this is the first route in the app then simply return the child without animation
      return child;
    }
    return FadeTransition(opacity: animation,child: child,);

  }
}