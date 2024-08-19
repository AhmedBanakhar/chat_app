import 'package:chat_app/Services/auth/auth_service.dart';
import 'package:chat_app/components/my_settings_list_tile.dart';
import 'package:chat_app/pages/blocked_user_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  //? confirm user wants to delete accout
  void userWantsToDeleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Account'),
              content:
                  const Text('Are you sure you want to delete your account?'),
              actions: [
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.background),
                  ),
                ),
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.background),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    //?if the user confirm

    if (confirm) {
      //! delete account
      try {
        await AuthService().deleteAccount();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
          (Route<dynamic> route) => false, // إزالة جميع الصفحات السابقة
        );
      } catch (e) {
        //! Handle any error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Center(child: Text('S E T T I N G S')),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      //?dark mode
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            //mainAxisAlignment:  MainAxisAlignment.start,
            children: [
              MySettingsListTile(
                title: 'Dark Mode',
                action: CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                ),
                color: Theme.of(context).colorScheme.secondary,
                textcolor: Theme.of(context).colorScheme.inversePrimary,
              ),
              //?SHOW BLOCKED USERS
              MySettingsListTile(
                title: 'Show Blocked Users',
                action: IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlockedUsersPage())),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  color: Theme.of(context).colorScheme.primary,
                ),
                color: Theme.of(context).colorScheme.secondary,
                textcolor: Theme.of(context).colorScheme.inversePrimary,
              ),
              //?delete account
              MySettingsListTile(
                  title: 'Delete Account',
                  action: IconButton(
                      onPressed: () => userWantsToDeleteAccount(context),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.background),
                  color: Colors.red,
                  textcolor: isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.background)
            ],
          ),
        ),
      ),
    );
  }
}
