import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String? globalUserId;
String? globalUsername;
ValueNotifier<String?> globalselectedCategoryNotifier =
    ValueNotifier<String?>(null);
List<DocumentSnapshot>? globalcategories = [];
List<DocumentSnapshot>? globalcategoryResource = [];
bool? globalisLoadingCategories = true;

Future<void> globalfetchCategoryResource(BuildContext context, String s) async {
  try {
    if (globalselectedCategoryNotifier.value != null &&
        globalselectedCategoryNotifier.value!.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ResourcesPublished')
          .doc(globalselectedCategoryNotifier.value)
          .collection('entries')
          .get();

      globalcategoryResource = snapshot.docs;
      print(
          'Fetched ${globalselectedCategoryNotifier.value} ${globalcategoryResource!.length}');
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
  globalselectedCategoryNotifier.addListener(() async {
    await globalfetchCategoryResource(
        context, globalselectedCategoryNotifier.value ?? '');
  });
}
