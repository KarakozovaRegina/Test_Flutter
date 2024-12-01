import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{

  final Function()? onTap;
  final String text;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:  Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Color.fromRGBO(250, 128, 114, 1),
          borderRadius: BorderRadius.circular(20.0),
        ),

        child: Center(
          child: Text(text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}