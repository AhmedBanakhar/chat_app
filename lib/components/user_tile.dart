import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;

  final void Function()? onTap;
  final int unreadMessagesCount;
  const UserTile(
      {super.key,
      required this.text,
      required this.onTap,
      this.unreadMessagesCount = 0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                //icon
                const Icon(Icons.person),
                const SizedBox(
                  width: 20,
                ),
                // user name
                Text(text,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontWeight: FontWeight.bold,fontSize: 17),),
              ]),
              unreadMessagesCount > 0
                  ? Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        child: Text(
                          unreadMessagesCount.toString(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
