import 'package:flutter/material.dart';

class MyTextFiled extends StatelessWidget {
  final String hinText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  const MyTextFiled({
    super.key,
    required this.hinText, required this.obscureText, required this.controller, this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
  focusNode: focusNode,
  controller: controller,
  obscureText: obscureText,
  decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0), // تحديد الزوايا الدائرية
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0), // تحديد الزوايا الدائرية
      borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
    ),
    fillColor: Theme.of(context).colorScheme.background,
    filled: true,
    hintText: hinText,
    hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
  ),
),
    );
  }
}
