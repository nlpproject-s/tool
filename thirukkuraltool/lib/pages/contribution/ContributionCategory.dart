import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thirukkuraltool/globals.dart';

class ContributionCategory extends StatefulWidget {
  final String category;

  ContributionCategory(this.category);

  @override
  _ContributionCategoryState createState() => _ContributionCategoryState();
}

class _ContributionCategoryState extends State<ContributionCategory> {
  List<DocumentSnapshot> _resources = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ResourcePublished')
          .where('category', isEqualTo: widget.category)
          .limit(50)
          .get();

      setState(() {
        _resources = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load resources: $e')),
      );
    }
  }

  void _addNewDiscussion() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController literatureController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Discussion'),
          content: SingleChildScrollView(
            child: Column(
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
                TextField(
                  controller: literatureController,
                  decoration: InputDecoration(labelText: 'Literature'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String title = titleController.text.trim();
                String description = descriptionController.text.trim();
                String literature = literatureController.text.trim();

                if (title.isNotEmpty &&
                    description.isNotEmpty &&
                    literature.isNotEmpty) {
                  // Get current user information
                  DocumentSnapshot userDoc = await FirebaseFirestore.instance
                      .collection('User')
                      .doc(
                          globalUserId) // Replace globalUserId with your actual user ID
                      .get();

                  String creatorName = userDoc['name'] ?? 'Unknown';

                  // Add to Firestore
                  await FirebaseFirestore.instance
                      .collection('Discussion')
                      .add({
                    'createdAt': FieldValue.serverTimestamp(),
                    'createdBy': globalUserId, // Replace with actual user ID
                    'creator': creatorName,
                    'description': description,
                    'favouritesCount': 0,
                    'likesCount': 0,
                    'literature': literature.toLowerCase(),
                    'tags': [],
                    'title': title,
                  });

                  // Close the dialog
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Discussion created successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All fields are required')),
                  );
                }
              },
              child: Text('Submit'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category: ${widget.category}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _resources.isEmpty
              ? Center(child: Text('No resources found for ${widget.category}'))
              : ListView.builder(
                  itemCount: _resources.length,
                  itemBuilder: (context, index) {
                    final resource = _resources[index];
                    final title = resource['title'] ?? 'No Title';
                    final description =
                        resource['description'] ?? 'No Description';

                    return ListTile(
                      title: Text(title),
                      subtitle: Text(description),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Add functionality for tapping a resource
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDiscussion,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ContributePage extends StatelessWidget {
  final String category;

  ContributePage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contribute to $category'),
      ),
      body: Center(
        child: Text(
          'Contribute Page for $category',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
