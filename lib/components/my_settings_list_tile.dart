import 'package:flutter/material.dart';

class MySettingsListTile extends StatelessWidget {
  final String title;
  final Widget action;
  final Color color;
  final Color textcolor;
  const MySettingsListTile(
      {super.key,
      required this.title,
      required this.action,
      required this.color, required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25,right: 25,top: 10),
      padding: const EdgeInsets.only(left: 25,right: 25,top: 20,bottom: 20),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //title
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textcolor),
          ),
          //action
          action
        ],
      ),
    );
  }
}
