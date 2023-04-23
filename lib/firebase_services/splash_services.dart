

import 'dart:async';
import 'package:crudapp/UI/auth/login_screen.dart';
import 'package:crudapp/UI/firestore/firestore_list_screen.dart';
import 'package:crudapp/UI/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../UI/posts/post_screen.dart';

class SplashServices{

  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;

    final user  = auth.currentUser;

    if(user!= null){
      Timer(const Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadImage()));

      });

    }else{
      Timer(const Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));

      });
    }


  }

}