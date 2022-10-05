import 'package:flutter/material.dart';

class CustomNavigator {  
  static navigateTo(context, widget) {
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).requestFocus(FocusNode());
    return Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => widget)
    );
  }

  static pushReplacement(context,widget){
    try{
      return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => widget),(Route<dynamic> route) => false);
    }
    catch(e){
      return Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget)
      );
    }
  }

}