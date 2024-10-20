import 'package:flutter/material.dart';
import 'package:thirukkuraltool/landingpage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/authentication/login.dart';
import 'landingpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return SignInPage();
            }
            // return VideosPage();
            // return ChatbotPage();
            //return HomeScreen();
            //return QuizPage();
          },
        ));
  }
}
