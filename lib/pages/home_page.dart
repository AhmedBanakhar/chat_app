import 'package:chat_app/Services/auth/auth_service.dart';
import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/Services/chat/chat_service.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // chat & auth services
  final AuthService _auth = AuthService();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.secondary,
       floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.background,
            onPressed: () {
               Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                //keep the firist route(Auth Gate)
                (route) => route.isFirst);
            },
            child:const Icon(Icons.refresh)),
      appBar: AppBar(
        title: const Center(child: Text('U S E R S')),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  //build list of user excpet for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStreamExceptBlockedUsers(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching users'));
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        //retrun list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all users excpet current user
    if (userData['email'] != _auth.getcurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () async {
          //? mark all messages in this chat page as read
          await _chatService.markMessageAsRead(userData["uid"]);

          //? tapped on a user -> go to chat page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        receiveEmail: userData["email"],
                        receiveId: userData['uid'],
                      )));
        },
        unreadMessagesCount: userData['unreadCount'],
      );
    } else {
      return Container();
    }
  }
}
