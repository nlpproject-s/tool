import 'package:flutter/material.dart';
import 'package:thirukkuraltool/pages/contribution/ContributionCategory.dart';

class ContributionsPage extends StatefulWidget {
  @override
  _ContributionsPageState createState() => _ContributionsPageState();
}

class _ContributionsPageState extends State<ContributionsPage> {
  String _selectedCategory = "Thirukkural"; // Default category

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

                  // Literature Categories Section
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                children: [
                  _literatureCard("+", "assets/add.png"),
                  _literatureCard("Thirukkural", "assets/thirukkural.png"),
                  _literatureCard(
                      "Silapathikaram", "assets/silapathikaram.png"),
                  _literatureCard("Tolkappiyam", "assets/tolkappiyam.png"),
                  _literatureCard("Ettutogai", "assets/ettutogai.png"),
                  _literatureCard("Pattupattu", "assets/pattupattu.png"),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),

            // Contributions Section
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

            // Dynamic Body Content
            Expanded(
              child: ContributionCategory(_selectedCategory),
            ),
          ],
        ),
      ),
    );
  }

  Widget _literatureCard(String title, String assetPath) {
    return GestureDetector(
      onTap: () {
        if (title == "+") {
          _showCreateCategory(context);
        } else {
          setState(() {
            _selectedCategory = title;
          });
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
              // maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // final title = titleController.text;
              // final description = descriptionController.text;
              // DocumentReference docRef = await FirebaseFirestore.instance
              //     .collection('Discussion')
              //     .add({
              //   'title': title,
              //   'description': description,
              //   'createdAt': Timestamp.now(),
              // });
              // await FirebaseFirestore.instance
              //     .collection('SpecificDiscussion')
              //     .doc(docRef.id)
              //     .set({});

              // Navigator.of(context).pop();
            },
            child: Text('Create'),
          ),
        ],
      );
    },
  );
}
