import 'package:chat_app/Services/chat/chat_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String messageId;
  final String userId;
  

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isMe,
      required this.messageId,
      required this.userId});
  //show options
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              // report message button
              ListTile(
                  leading: const Icon(Icons.report),
                  title: const Text('Report'),
                  onTap: () {
                    Navigator.pop(context);
                    reportMessage(context, messageId, userId);
                  }),
              // block user button
              ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Block User'),
                  onTap: () {
                    Navigator.pop(context);
                    blockUser(context, userId);
                  }),

              //cancel buttom
              ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancel'),
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          ));
        });
  }

  //report message
  void reportMessage(BuildContext context, String messageId, String userId) {
    //show dialog
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Report Message'),
              content:
                  const Text('Are you sure you want to report this message'),
              actions: [
                // cancel bottun
                TextButton(
                  onPressed: () =>
                      //dismiss dialog
                      Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                //report button
                TextButton(
                  onPressed: () {
                    //dismiss dialog
                    ChatService().reportUser(userId, messageId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Message Reported')));
                  },
                  child: const Text('Report'),
                ),
              ]);
        });
  }

  //block usre

  void blockUser(BuildContext context, String userId) {
    //show dialog
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Report Message'),
              content: const Text('Are you sure you want to block this user'),
              actions: [
                // cancel bottun
                TextButton(
                  onPressed: () =>
                      //dismiss dialog
                      Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                //block button
                TextButton(
                  onPressed: () {
                    //dismiss dialog
                    ChatService().blockUser(userId);
                    //dismiss dialog
                    Navigator.pop(context);
                    // dismiss page
                    Navigator.pop(context);
                    //let user know of result
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User Blocked')));
                  },
                  child: const Text('Block'),
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    Color bubbleColor = isMe
        ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
        : (isDarkMode ? Colors.grey.shade800 : Theme.of(context).colorScheme.background);

    return GestureDetector(
      onLongPress: () {
        if (!isMe) {
          //show options
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(15.0),
            bottomRight: const Radius.circular(15.0),
            topLeft: isMe ? const Radius.circular(15.0) : Radius.zero,
            topRight: isMe ? Radius.zero : const Radius.circular(15.0),
          ),
        ),
        child:
         Text(
          message,

          style: TextStyle(
              color: isMe
                  ? Colors.white
                  : (isDarkMode ? Colors.white : Colors.black)),
        ),
        
      ),
      
    );
  }
}
