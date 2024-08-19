import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _messageStreamController = BehaviorSubject<RemoteMessage>();
  //? Request Permission: call this in main starup
  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or have not accepted permission');
    }
  }

  //? setup interaction
  Future<void> setupInteractions() async {
    //? user received message
    FirebaseMessaging.onMessage.listen((event) {
      print('Got a message whilst in the foreground! ${event.data}');
      _messageStreamController.sink.add(event);
    });
    //? user opened message
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Message clicked! ${event.data}');
    });
  }

  void dispose() {
    _messageStreamController.close();
  }

  //? Setup token listeners
  /**
   * each device has a token we will get this token so that we know which devuce 
   * to send a notification
   */
  Future<void> setupTokenListeners() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      saveTokenToDatabase(token);
    });
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

//? Save Device Token
  Future<void> saveTokenToDatabase(String? token) async {
    //? get current user id
    String? userId = await FirebaseAuth.instance.currentUser?.uid;
    //? if the current user is logged in & it has a device token .. save token to database
    if (userId != null && token != null) {
      //? save token to database
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .set({'fcmToken': token}, SetOptions(merge: true));
    }
  }

// ignore: slash_for_doc_comments
/**
 * Clear device token
 * itnis important to clear the device token in the case that the user logs out,
 * we do not want to be still sending notifications to the device
 * when any user logs back in the new device token will be saved
 */
  Future<void> clearDeviceToken(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });
      print('Token Cleared');
    } catch (e) {
      print('Error clearing token $e');
    }
  }
}
