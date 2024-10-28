import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thirukkuraltool/pages/kural/individualkural.dart';
import 'package:thirukkuraltool/pages/search/search.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  String _username = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String email = user.email ?? '';
      setState(() {
        _username = email.split('@')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: Kural(kuralIndex: 3, kuralText: "kuralText".toString()),
        );
  }
}
