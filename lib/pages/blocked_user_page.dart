import 'package:chat_app/Services/auth/auth_service.dart';
import 'package:chat_app/Services/chat/chat_service.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

// chat & auth service
  final AuthService authService = AuthService();
  final ChatService chatService = ChatService();

//show unblockBox
  void _showUnBlockBox(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Unblock User'),
                content: Text('Are you sure you want to unblock this user..?'),
                actions: [
                  //Cancel bottun
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      chatService.unblockUser(userId);
                      Navigator.pop(context);
                      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          const SnackBar(content: const Text('Unblock User')));
                    },
                    child: const Text('Unblock'),
                  ),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    //get current users id
    final userId = authService.getcurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Blocked Users')),
        actions: [],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final blockedUsers = snapshot.data ?? [];

          //no users
          if (blockedUsers.isEmpty) {
            return Center(child: Text('No blocked users'));
          }
          //load complet
          return ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, i) {
                final user = blockedUsers[i];
                return UserTile(
                    text: user['email'],
                    onTap: () => _showUnBlockBox(context, user['uid']));
              });
        },
      ),
    );
  }
}
