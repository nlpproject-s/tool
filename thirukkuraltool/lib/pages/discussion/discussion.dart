import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Discussion extends StatefulWidget {
  @override
  _Discussion createState() => _Discussion();
}

class _Discussion extends State<Discussion> {
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
