import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/textfield.dart';
import '../service/firebase_authentication.dart';

class RegisterPage extends StatefulWidget{
  final Function()? onTap;
  RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}



class _RegisterPageState extends State<RegisterPage>{

  AuthService service = AuthService();

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // sign up
  void userSingUp() async{

    //try creating new user
    try{
     if(passwordController.text == confirmpasswordController.text){
       String encryptedPassword = service.encryptPassword(passwordController.text);
       await FirebaseAuth.instance.createUserWithEmailAndPassword(
           email: emailController.text,
           password: encryptedPassword);
     }
     else{
       showMessage("Password isn't correct");
     }
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

  void showMessage(String message){
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
                    SizedBox(height: 20,),

                    //confirm password
                    MyTextField(
                      controller: confirmpasswordController,
                      hintText: "Confirm Password",
                      obscureText: true,
                    ),
                    SizedBox(height: 40,),

                    // button for sign in
                    MyButton(onTap: userSingUp,text: "Sing up"),
                    SizedBox(height: 10,),

                    //sing up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Do you have a account?",
                          style: TextStyle( color: Color(0xFF5E5E5E)),),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text("Login now",
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
