import 'package:flutter/material.dart';

class MyTaskField extends StatelessWidget{

  final controller;
  final String mylabelText;
  final String hintText;


  const MyTaskField({
    super.key,
    required this.controller,
    required this.mylabelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none
            ),
            labelText: mylabelText, // Убедитесь, что это переменная
            hintText: hintText, // Убедитесь, что это переменная
          ),
        ),
      ),
    );
  }
}