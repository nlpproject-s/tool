import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thirukkuraltool/landingpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/authentication/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   if (snapshot.hasData) {
            //     _showWordOfTheDayDialog(context);
            //   } else {
            //     _showWordOfTheDayDialog(context);
            //   }
            // });

            if (snapshot.hasData) {
              return HomePage();
            } else {
              return SignInPage();
            }
          },
        ));
  }

  Future<void> _showWordOfTheDayDialog(BuildContext context) async {
    // String word = '', meaning = '';
    // DocumentSnapshot<Map<String, dynamic>> snapshot =
    //     await FirebaseFirestore.instance.collection('Word').doc('agaram').get();
    // if (snapshot != null) {
    //   word = snapshot.data()?['-1'] ?? 'wordnotfound';
    // }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text("New word to learn"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Thirukkural"),
              SizedBox(height: 10),
              Text(
                "Explanation of the word in this context.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
