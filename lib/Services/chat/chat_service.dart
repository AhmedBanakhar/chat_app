import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  //get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //? get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((sanpshot) {
      return sanpshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

//? GET ALL USERS STREAM EXPCEPT BLOCKED USERS
  Stream<List<Map<String, dynamic>>> getUsersStreamExceptBlockedUsers() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //? get blocked users id
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      //?get all users ids
      final usersSnapshot = await _firestore.collection('Users').get();

      //?returen as stream list,excluding current user and block users
      final usersData = await Future.wait(
        //?get all docs
        usersSnapshot.docs
            //?excluding current user and blocked user
            .where((doc) =>
                doc.data()['email'] != currentUser.email &&
                !blockedUserIds.contains(doc.id))
            .map((doc) async {
          //?look at each user
          final userData = doc.data();
          //?and their chat rooms
          final chatRoomID = [currentUser.uid, doc.id]..sort();
          //?count the number of unread message
          final unreadMessageSnapsgot = await _firestore
              .collection('chat_rooms')
              .doc(chatRoomID.join('_'))
              .collection('messages')
              .where('receiverId', isEqualTo: currentUser.uid)
              .where('isRead', isEqualTo: false)
              .get();
          userData['unreadCount'] = unreadMessageSnapsgot.docs.length;
          return userData;
        }).toList(),
      );
      return usersData;
    });
  }

  //? send message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create new message
    Message newmessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
        isRead: false);

    //construct chat room ID for the two users{soted to ensure uniqueness}
    List<String> ids = [currentUserID, receiverId];
    ids.sort(); //sort the ids{this ensure the chatroomID is the same for any 2 users}
    String chatRoomID = ids.join('_');

    //add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newmessage.toMap());
  }

  //? get message
  Stream<QuerySnapshot> getMessage(String UserID, otherUserID) {
    //contruct a chatroom ID for the two users
    List<String> ids = [UserID, otherUserID];
    ids.sort(); //sort the ids{this ensure the chatroomID is the same for any
    String chatroomID = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatroomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  //? mark message as read
  Future<void> markMessageAsRead(String recevierid) async {
    //? get current user id
    final currentUserID = _auth.currentUser!.uid;
    //? get chat room
    List<String> ids = [currentUserID, recevierid];
    ids.sort();
    String chatRoomID = ids.join('_');

    //? unread message
    final unreadMessageQuery = _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserID)
        .where('isRead', isEqualTo: false);
    final unreadMessageSnapshot = await unreadMessageQuery.get();

    //? go through each message and mark as read
    for (var doc in unreadMessageSnapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  //? REBORT USER
  Future<void> reportUser(String userID, String messageId) async {
    //get current user info
    final currentUser = _auth.currentUser;
    //add report to database
    final report = {
      'reportedBy': currentUser!.uid,
      'messageid': messageId,
      'messagedOwnerId': userID,
      'timestamp': Timestamp.now(),
    };
    await _firestore.collection('Reports').add(report);
  }

  //? BLOCK USER
  Future<void> blockUser(String userID) async {
    //get current user info
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userID)
        .set({});
    notifyListeners();
  }

  //? UNBLOCK USER
  Future<void> unblockUser(String blockeduserID) async {
    //get current user info
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockeduserID)
        .delete();
  }

  //? GET BLOCKED USER STREAM
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get list of blocked users id
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      final userDocs = await Future.wait(
        blockedUserIds
            .map((id) => _firestore.collection('Users').doc(id).get()),
      );
      //return as List
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
