import 'package:flutter/material.dart';
import 'package:thirukkuraltool/landingpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/authentication/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int val = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (val == 0) {
            _showWordOfTheDayDialog(context);
            val += 1;
          }
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return SignInPage();
          }
        },
      ),
    );
  }

  Future<void> _showWordOfTheDayDialog(BuildContext context) async {
    try {
      // Fetching word from Firestore
      // DocumentSnapshot<Map<String, dynamic>> snapshot =
      //     await FirebaseFirestore.instance
      //         .collection('Word')
      //         .doc('1')
      //         .get();

      String kural = 'agaram';
      String explanation = 'first letter';

      // if (snapshot.exists) {
      //   // Extract data if exists
      //   kural = snapshot.data()?['kural'] ?? 'Kural not found';
      //   explanation =
      //       snapshot.data()?['explanation'] ?? 'Explanation not found';
      // }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.zero,
            content: Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Word of the Day",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          kural,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          explanation,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.cancel, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); 
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {
                      Color:Colors.red,
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error fetching Word of the Day: $e");
    }
  }
}
