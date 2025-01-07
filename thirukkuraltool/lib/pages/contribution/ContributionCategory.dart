import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thirukkuraltool/globals.dart';

class ContributionCategory extends StatefulWidget {
  ContributionCategory();

  @override
  _ContributionCategoryState createState() => _ContributionCategoryState();
}

class _ContributionCategoryState extends State<ContributionCategory> {
  // List<DocumentSnapshot> _resources = [];
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // _loadResources();
  }

  // Future<void> _loadResources() async {
  //   try {
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('ResourcePublished')
  //         .where('category', isEqualTo: widget.category)
  //         .limit(50)
  //         .get();

  //     setState(() {
  //       _resources = snapshot.docs;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to load resources: $e')),
  //     );
  //   }
  // }

  void _addNewContribution() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController literatureController = TextEditingController();
    final TextEditingController literaturemeaningController =
        TextEditingController();
    final List<Map<String, String>> wordMeanings = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final TextEditingController wordController =
                TextEditingController();
            final TextEditingController meaningController =
                TextEditingController();

            return AlertDialog(
              title:
                  Text('Contribute to ${globalselectedCategoryNotifier.value}'),
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
                      decoration:
                          InputDecoration(labelText: 'Literature Content'),
                    ),
                    TextField(
                      controller: literatureController,
                      decoration: InputDecoration(labelText: 'Content Meaning'),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Add Word Meaning'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: wordController,
                                    decoration:
                                        InputDecoration(labelText: 'Word'),
                                  ),
                                  TextField(
                                    controller: meaningController,
                                    decoration:
                                        InputDecoration(labelText: 'Meaning'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    String word = wordController.text.trim();
                                    String meaning =
                                        meaningController.text.trim();
                                    if (word.isNotEmpty && meaning.isNotEmpty) {
                                      setState(() {
                                        wordMeanings.add(
                                            {'word': word, 'meaning': meaning});
                                      });
                                      wordController.clear();
                                      meaningController.clear();
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Both fields are required')),
                                      );
                                    }
                                  },
                                  child: Text('Add'),
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
                      },
                      child: Text('Add Word Meaning'),
                    ),
                    Text(
                      'Word Meanings:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    for (var wm in wordMeanings)
                      ListTile(
                        title: Text(wm['word']!),
                        subtitle: Text(wm['meaning']!),
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
                    String meaning = literaturemeaningController.text.trim();
                    if (title.isNotEmpty &&
                        description.isNotEmpty &&
                        literature.isNotEmpty) {
                      DocumentSnapshot userDoc = await FirebaseFirestore
                          .instance
                          .collection('User')
                          .doc(globalUserId)
                          .get();
                      String creatorName = userDoc['name'] ?? 'Unknown';
                      await FirebaseFirestore.instance
                          .collection('ResourcesPublished')
                          .doc(globalselectedCategoryNotifier.value)
                          .collection('entries')
                          .add({
                        'createdAt': FieldValue.serverTimestamp(),
                        'createdBy': globalUserId,
                        'creator': creatorName,
                        'title': title,
                        'description': description,
                        'favouritesCount': 0,
                        'likesCount': 0,
                        'literature': literature,
                        'meaning': meaning,
                        'wordMeanings': wordMeanings,
                      });
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Your Contribution has been published successfully')),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category: ${globalselectedCategoryNotifier.value}'),
      ),
      body: (globalcategoryResource == null || globalcategoryResource!.isEmpty)
          ? Center(
              child: Text(
                'No resources found for $globalselectedCategoryNotifier.value',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: globalcategoryResource!.length,
              itemBuilder: (context, index) {
                final resource = globalcategoryResource![index].data()
                        as Map<String, dynamic>? ??
                    {};
                final title = resource['title'] ?? 'No Title';
                final description = resource['description'] ?? 'No Description';

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      print('Tapped on $title');
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewContribution,
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
