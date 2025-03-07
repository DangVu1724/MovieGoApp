import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moviego/Services/local_notification_service.dart';
import 'package:moviego/firebase_options.dart';
import 'package:moviego/pages/sign_in_API.dart';
import 'package:moviego/widgets/bottom_app_bar.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  firebaseMessaging.getToken().then((token) {
    print("token is $token");
  });

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  LocalNotificationService.initialize();

  FirebaseMessaging.onMessage.listen((message) {
    if (message.notification != null) {
      print(message.notification!.title);
      print('Message: ${message.notification!.body}');
    }

    LocalNotificationService.display(message);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), 
            );
          } else if (snapshot.hasData) {
            return const MainScreen(); 
          } else {
            return const SignInAPI(); 
          }
        },
      ),
    );
  }
}
