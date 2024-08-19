import 'package:chat_app/components/my_list_tile.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Services/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout(BuildContext context) {
    final auth = AuthService();
    auth.signOut();
    //? then navigator to initial route (Auth Gate / Login Reigieter Page)
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            //?  applogo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: DrawerHeader(
                  child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Image.asset(
                    'images/chat.png',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )),
            ),

            //? home list tile
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 10),
              child: MyDrawerListTile(
                title: 'H O M E',
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),

            //? settings list tile
            Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 10),
                child: MyDrawerListTile(
                  title: 'S E T T I N G S',
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                  },
                )),

            //? logout list tile
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: MyDrawerListTile(
              title: 'L O G O U T',
              onTap: () => logout(context),
              icon: Icons.logout,
            ),
          )
        ],
      ),
    );
  }
}
