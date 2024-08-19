import 'package:chat_app/Services/auth/auth_service.dart';
import 'package:chat_app/Services/chat/chat_service.dart';
import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfiled.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiveEmail;
  final String receiveId;
  const ChatPage(
      {super.key, required this.receiveEmail, required this.receiveId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messagecontroller = TextEditingController();

  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  //for textfield focus

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //cause a delay so that the keyboard has time to show up
        //then the amount of remaining space will be calculated
        //then scroll down
        Future.delayed(const Duration(milliseconds: 1500), () => scrollDown());
      }
    });
    //wait a bit for listview to be built, then scroll to bottun
    Future.delayed(const Duration(milliseconds: 1500), () => scrollDown());
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    _messagecontroller.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void sendMessage() async {
    if (_messagecontroller.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiveId, _messagecontroller.text);
      _messagecontroller.clear();
      scrollDown();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: Center(
            child: Text(
          widget.receiveEmail,
          style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.bold),
        )),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                //keep the firist route(Auth Gate)
                (route) => route.isFirst);
          },
        ),
      ),
      body: Column(children: [
        Expanded(
          child: _buildMessageList(),
        ),
        _buildMessageInput(),
      ]),
    );
  }

  //buildMessageList
  Widget _buildMessageList() {
    String senderID = _authService.getcurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessage(widget.receiveId, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching users'));
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //is current user
    bool isCurrentUser = data['senderID'] == _authService.getcurrentUser()!.uid;

    // align message to the rigth if sender is the current user, otherwies left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(
              message: data['message'],
              isMe: isCurrentUser,
              messageId: doc.id,
              userId: data['senderID'],
            )
          ],
        ));
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextFiled(
              hinText: 'Tayp a message',
              obscureText: false,
              controller: _messagecontroller,
              focusNode: myFocusNode,
            ),
          ),
          Container(
              decoration:
                  BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              margin: EdgeInsets.only(right: 25),
              child: IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ))),
        ],
      ),
    );
  }
}
