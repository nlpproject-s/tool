import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../globals.dart';
import '../../landingpage.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    print("Initializing app...");

    // Use authStateChanges to monitor the user's authentication state
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        // User is logged in, fetch their data
        await _fetchUserData(user.uid);
        await _fetchCategories();
        await globalfetchCategoryResource(
            context, globalselectedCategoryNotifier.value!);

        // Navigate to HomePage only if the widget is still mounted
        if (mounted) {
          Future.delayed(Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          });
        }
      } else {
        // No user is logged in, navigate to SignInPage
        if (mounted) {
          Future.delayed(Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            }
          });
        }
      }
    });
  }

  Future<void> _fetchCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ContributionCategories')
          .get();

      List<QueryDocumentSnapshot> sortedDocs = snapshot.docs
          .where((doc) => (doc['category'] ?? '').toString().contains('+'))
          .toList();
      sortedDocs.addAll(snapshot.docs
          .where((doc) => !(doc['category'] ?? '').toString().contains('+'))
          .toList());

      globalcategories = sortedDocs;
      globalisLoadingCategories = false;
      globalselectedCategoryNotifier.value = "Thirukkural";
    } catch (e) {
      setState(() {
        globalisLoadingCategories = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch categories: $e')));
    }
    print("Fetched categories: ${globalcategories!.length}");
  }

  Future<void> _fetchUserData(String userId) async {
    if (globalUserId == null || globalUsername == null) {
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        User? user = _auth.currentUser;
        if (user != null) {
          globalUserId = user.uid;
          globalUsername = user.displayName ?? 'User';
          print("Fetched user data: $globalUsername ($globalUserId)");
        } else {
          print("User details are not available.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.android, size: 100), // Your app icon
            SizedBox(height: 20),
            Text(
              "Loading...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Loading spinner
          ],
        ),
      ),
    );
  }
}
