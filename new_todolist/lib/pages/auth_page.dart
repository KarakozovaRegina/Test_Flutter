import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_todolist/pages/login_or_register_page.dart';
import 'package:new_todolist/pages/login_page.dart';
import 'package:new_todolist/pages/taks_page.dart';

class AuthPage extends StatelessWidget{
  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (contex, snapshot){
            // user is logged in
            if(snapshot.hasData){
              return TasksPage();
            }

            // user is not logged in
            else{
              return LoginOrRegisterPage();
            }
          }),
    );
  }
}