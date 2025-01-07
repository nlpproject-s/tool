import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thirukkuraltool/globals.dart';
import 'package:thirukkuraltool/pages/contribution/ContributionCategory.dart';

class ContributionsPage extends StatefulWidget {
  @override
  _ContributionsPageState createState() => _ContributionsPageState();
}

class _ContributionsPageState extends State<ContributionsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.01),
                  Text(
                    "Explore Contributions & Insights",
                    style: TextStyle(
                      fontSize: width * 0.045,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "Literature Categories",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.01),

            SizedBox(
              height: height * 0.15,
              child: globalisLoadingCategories == true
                  ? Center(child: CircularProgressIndicator())
                  : globalcategories!.isEmpty
                      ? Center(child: Text("No categories found"))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          itemCount: globalcategories!.length,
                          itemBuilder: (context, index) {
                            final categoryData = globalcategories![index];
                            final categoryName =
                                categoryData['category'] ?? 'Unknown';
                            final imagePath =
                                'assets/${categoryData['category']}.png';

                            return _literatureCard(categoryName, imagePath);
                          },
                        ),
            ),
            SizedBox(height: height * 0.02),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contributions",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.08,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                children: [
                  _tabButton("Popular", Icons.star),
                  _tabButton("Trending", Icons.trending_up),
                  _tabButton("Featured", Icons.featured_play_list),
                  _tabButton("Latest", Icons.new_releases),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),

            Expanded(
              child: ContributionCategory(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _literatureCard(String title, String assetPath) {
    return GestureDetector(
      onTap: () async {
        if (title == "+") {
          _showCreateCategory(context);
        } else {
          globalselectedCategoryNotifier.value = title;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(assetPath),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.black),
          SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

void _showCreateCategory(BuildContext context) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create New Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();

              if (title.isNotEmpty && description.isNotEmpty) {
                try {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('ContributionCategories')
                      .where('category', isEqualTo: title)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Category Exists'),
                          content: Text(
                              'The category "$title" already exists. What would you like to do?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Cancel button action
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Find button action
                                globalselectedCategoryNotifier.value = title;
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Category "$title" has been selected'),
                                  ),
                                );
                              },
                              child: Text('Find'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    DocumentReference newCategoryRef = await FirebaseFirestore
                        .instance
                        .collection('ContributionCategories')
                        .add({
                      'category': title,
                      'description': description,
                      'createdAt': Timestamp.now(),
                      'createdBy': globalUserId,
                    });

                    await FirebaseFirestore.instance
                        .collection('ResourcesPublished')
                        .doc(title)
                        .collection('entries')
                        .add({
                      'categoryId': newCategoryRef.id,
                      'description': description,
                      'createdAt': Timestamp.now(),
                      'createdBy': globalUserId,
                    });
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Category and subcollection created successfully')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error creating category: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            child: Text('Create'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}
