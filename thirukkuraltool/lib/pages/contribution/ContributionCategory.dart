import 'package:flutter/material.dart';

class ContributionCategory extends StatelessWidget {
  final String category;

  ContributionCategory(this.category);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Selected Category: $category",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
