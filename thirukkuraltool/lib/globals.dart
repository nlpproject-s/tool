library globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String? globalUserId;
String? globalUsername;
String? globalselectedCategory;
ValueNotifier<String?> globalselectedCategoryNotifier =
    ValueNotifier<String?>(null);
List<DocumentSnapshot>? globalcategories = [];
List<DocumentSnapshot>? globalcategoryResource = [];
bool? globalisLoadingCategories = true;

Future<void> globalfetchCategoryResource(BuildContext context) async {
  try {
    if (globalselectedCategory != null && globalselectedCategory!.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ResourcesPublished')
          .doc(globalselectedCategory)
          .collection('entries')
          .get();

      globalcategoryResource = snapshot.docs;
      print(
          'Fetched ${globalselectedCategory} ${globalcategoryResource!.length}');
    } else {
      throw Exception('No category selected');
    }
  } catch (e) {
    print('Error fetching resources: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to fetch resources: $e')),
    );
  }
}

void setupCategoryListener(BuildContext context) {
  print('called');
  globalfetchCategoryResource(context);
}
