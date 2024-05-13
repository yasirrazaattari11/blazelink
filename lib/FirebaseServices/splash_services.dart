import 'package:blaze_link/UIs/Auth/login_screen.dart';
import 'package:blaze_link/UIs/Firestore/firstor_list_screen.dart';
import 'package:blaze_link/UIs/Posts/home_screen.dart';
import 'package:blaze_link/UIs/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashServices {
  void isLogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    if(user != null){
      Timer(Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }else{
      Timer(Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }

  }
}
