

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Utils{

  static showToastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


}