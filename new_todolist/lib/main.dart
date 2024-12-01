import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_todolist/api/firebase_api.dart';
import 'package:new_todolist/pages/auth_page.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
   await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyDjNaubP5CHDVRvpmam7i_m3S29N9CQB7U", appId: "1:702745256266:web:b0c696730c93eba7bea1b3", messagingSenderId: "702745256266", projectId: "my-todolist-19dc4"));
  }else{
    await Firebase.initializeApp(
    );
  }

  await FirebaseApi().initNotifications();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}

