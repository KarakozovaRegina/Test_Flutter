import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  singUp(email, password,confirmpassword) async{

    //try creating new user
    try{
      if(password == confirmpassword){
        String encryptedPassword = encryptPassword(password);
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: encryptedPassword);
      }
      else{
        print("Password isn't correct");
      }
    }on FirebaseAuthException catch(e){

      if(e.code=='user-not-found'){
        print(e.code);
      }
      else if(e.code=='wrong-password'){
        print(e.code);
      }
    }

  }

}

