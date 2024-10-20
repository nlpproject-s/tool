import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikePage extends StatefulWidget {
  @override
  _LikePage createState() => _LikePage();
}

class _LikePage extends State<LikePage> {
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
    return Scaffold();
  }
}
