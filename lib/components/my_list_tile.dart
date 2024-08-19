import 'package:flutter/material.dart';

class MyDrawerListTile extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final IconData icon;
  const MyDrawerListTile(
      {super.key,
      required this.title,
      required this.onTap,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        onTap: onTap);
  }
}
