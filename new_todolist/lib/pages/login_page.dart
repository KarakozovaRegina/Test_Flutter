import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_todolist/components/button.dart';
import 'package:new_todolist/components/textfield.dart';

import '../service/firebase_authentication.dart';

class LoginPage extends StatefulWidget{
  final Function()? onTap;
  LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage>{

  AuthService service = AuthService();

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in
  void userSingIn() async{

//try sing in
    try{
      String encryptedPassword = service.encryptPassword(passwordController.text);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: encryptedPassword);
    }on FirebaseAuthException catch(e){

      if(e.code=='user-not-found'){
        showWrongSingIn(e.code);
      }
      else if(e.code=='wrong-password'){
        showWrongSingIn(e.code);
      }
    }

  }

  //wrong email and password
  void showWrongSingIn(String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.grey[100],
     body: SafeArea(
         child: Center(
           child:SingleChildScrollView(
             child:            Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 //email
                 MyTextField(
                   controller: emailController,
                   hintText: "Email",
                   obscureText: false,
                 ),
                 SizedBox(height: 20,),

                 //password
                 MyTextField(
                   controller: passwordController,
                   hintText: "Password",
                   obscureText: true,
                 ),
                 SizedBox(height: 40,),

                 // button for sign in
                 MyButton(onTap: userSingIn, text: "Sing in"),
                 SizedBox(height: 10,),

                 //sing up
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text("Not a account?",
                       style: TextStyle( color: Color(0xFF5E5E5E)),),
                     const SizedBox(width: 5,),
                     GestureDetector(
                       onTap: widget.onTap,
                       child: Text("Register now",
                         style: TextStyle(
                             color: Colors.blue[200],
                             fontWeight: FontWeight.bold
                         ),
                       ),
                     ),

                   ],
                 ),

               ],
             ),
           )
         )),
   );
  }
}