import 'package:chat_app/notifications/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// get current user
  User? getcurrentUser() {
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // حفظ معلومات المستخدم إذا لم تكن موجودة بالفعل
      await _firestore
          .collection('Users')
          .doc(result.user!.uid)
          .set({'uid': result.user!.uid, 'email': email},
          SetOptions(merge: true)
          );
          NotificationService().setupInteractions();

      return result;
    } on FirebaseAuthException catch (e) {
      //throw Exception(e.code);
      return Future.error(e.code);
    }
  }

  //sign up

  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //save user info in a separate doc
      await _firestore
          .collection('Users')
          .doc(result.user!.uid)
          .set({'uid': result.user!.uid, 'email': email});
          NotificationService().setupInteractions();
      return result;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.code);
    }
  }

  //sign out
  Future<void> signOut() async {
    String? userId=_auth.currentUser?.uid;
    if(userId!=null){
       NotificationService().clearDeviceToken(userId);
    }
    return await _auth.signOut();
  }

  // delete account
  Future<void> deleteAccount() async {
    User? user = getcurrentUser();
    if (user != null) {
      //delete the user from thr firestore
      await _firestore.collection('Users').doc(user.uid).delete();
      //delete the user suth record
      await user.delete();
    }
  }

  // possible error message
  // String getErrorMessage(String errorCode) {
  //   switch (errorCode) {
  //     case 'invalid-email':
  //       return 'Invalid email address';
  //     case 'user-not-found':
  //       return 'User not found';
  //     case 'wrong-password':
  //       return 'Wrong password';
  //     case 'email-already-in-use':
  //       return 'Email already in use';
  //     default:
  //       return 'An unexcpected error occurred. Plesae try again later';
  //   }
  // }
  String getErrorMessage(String errorCode) {
  print('=====================================$errorCode');
  switch (errorCode) {
    case 'user-not-found':
      return 'هذا الحساب غير موجود. يرجى التحقق من البريد الإلكتروني.';
    case 'wrong-password':
      return 'كلمة المرور غير صحيحة.';
    case 'weak-password':
      return 'كلمة المرور ضعيفه.';
    case 'invalid-email':
      return 'عنوان البريد الإلكتروني غير صالح.';
    case 'email-already-in-use':
      return 'البريد الإلكتروني مستخدم بالفعل.';
    default:
      return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى لاحقًا.';
  }
}
}
