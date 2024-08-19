import 'package:chat_app/Services/auth/auth_get.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/notifications/notification_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //? setup notification background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessageBackgroundHandler);
  //? request notification permission
  final noti = NotificationService();
  await noti.requestPermission();
  noti.setupInteractions();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

//? Notification Background Handler
Future<void> firebaseMessageBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message:${message.messageId}');
  print('Message data:${message.data}');
  print('Message Notification:${message.notification?.title}');
  print('Message Notification:${message.notification?.body}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        // home: const AuthGate(),
        theme: Provider.of<ThemeProvider>(context).themeData,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthGate(),
        });
  }
}
