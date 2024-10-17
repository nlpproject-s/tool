import 'package:flutter/material.dart';
import 'package:thirukkuraltool/landingpage.dart';

void main() {
  runApp(ThirukkuralApp());
}

class ThirukkuralApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ThirukkuralHome(),
    );
  }
}
