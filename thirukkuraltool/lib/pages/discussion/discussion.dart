import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'discussionChat.dart'; // Import your discussion chat page
import '../../globals.dart';

class Discussion extends StatefulWidget {
  final String currentUser;

  const Discussion({Key? key, required this.currentUser}) : super(key: key);

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<Discussion> {
  late Stream<QuerySnapshot> _discussionStream;
  String? _selectedLiterature; // State variable to track the selected literature
  TextEditingController _searchController = TextEditingController(); // Search bar controller
  String _searchQuery = ''; // State variable for search query

  @override
  void initState() {
    super.initState();
    _discussionStream = FirebaseFirestore.instance.collection("Discussion").snapshots();
  }

  // Method to update the stream based on the selected literature or search query
  void _filterDiscussions() {
    setState(() {
      Query query = FirebaseFirestore.instance.collection("Discussion");

      // Apply search query filter if search query is provided
      if (_searchQuery.isNotEmpty) {
        query = query.where('title', isGreaterThanOrEqualTo: _searchQuery)
                     .where('title', isLessThanOrEqualTo: _searchQuery + '\uf8ff');
      }

      // Apply literature filter if selected
      if (_selectedLiterature != null && _selectedLiterature != 'None') {
        query = query.where("literature", isEqualTo: _selectedLiterature!.toLowerCase());
      }

      _discussionStream = query.snapshots();
    });
  }

  // Toggle like status and update Firestore
  Future<void> _toggleLike(String discussionId, bool isLiked) async {
    final userDoc = FirebaseFirestore.instance.collection('User').doc(globalUserId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot discussionSnapshot =
          await transaction.get(FirebaseFirestore.instance.collection('Discussion').doc(discussionId));

      int likesCount = discussionSnapshot['likesCount'];
      transaction.update(discussionSnapshot.reference, {
        'likesCount': isLiked ? likesCount - 1 : likesCount + 1,
      });

      if (isLiked) {
        transaction.update(userDoc, {
          'likes': FieldValue.arrayRemove([discussionId]),
        });
      } else {
        transaction.update(userDoc, {
          'likes': FieldValue.arrayUnion([discussionId]),
        });
      }
    });
  }

  // Toggle favorite status and update Firestore
  Future<void> _toggleFavorite(String discussionId, bool isFavorited) async {
    final userDoc = FirebaseFirestore.instance.collection('User').doc(globalUserId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot discussionSnapshot =
          await transaction.get(FirebaseFirestore.instance.collection('Discussion').doc(discussionId));

      int favoritesCount = discussionSnapshot['favouritesCount'];
      transaction.update(discussionSnapshot.reference, {
        'favouritesCount': isFavorited ? favoritesCount - 1 : favoritesCount + 1,
      });

      if (isFavorited) {
        transaction.update(userDoc, {
          'favourites': FieldValue.arrayRemove([discussionId]),
        });
      } else {
        transaction.update(userDoc, {
          'favourites': FieldValue.arrayUnion([discussionId]),
        });
      }
    });
  }

  // Add new discussion
  void _addNewDiscussion() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController literatureController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Discussion'),
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
              TextField(
                controller: literatureController,
                decoration: InputDecoration(labelText: 'Literature'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String title = titleController.text.trim();
                String description = descriptionController.text.trim();
                String literature = literatureController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty && literature.isNotEmpty) {
                  // Get current user information
                  DocumentSnapshot userDoc = await FirebaseFirestore.instance
                      .collection('User')
                      .doc(globalUserId)
                      .get();

                  String creatorName = userDoc['name'] ?? 'Unknown'; // Default if name is null

                  // Add to Firestore
                  await FirebaseFirestore.instance.collection('Discussion').add({
                    'createdAt': FieldValue.serverTimestamp(),
                    'createdBy': globalUserId,
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
    List<String> literatures = [
      'Thirukkural', 'Tholkappiyam', 'Kambaramayanam', 'Purananooru',
      'Silappathigaram', 'Manimegalai'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussions'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Search Bar
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      _filterDiscussions(); // Trigger the filtering when search query changes
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Space between search bar and dropdown
                // Literature Dropdown
                Container(
                  width: 150, // Adjust width as needed
                  child: DropdownButton<String>(
                    value: _selectedLiterature,
                    hint: Text('Literature'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLiterature = newValue;
                      });
                      _filterDiscussions(); // Trigger filtering when a new literature is selected
                    },
                    items: ['Literatues', ...literatures].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Discussions section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Discussions',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: StreamBuilder<QuerySnapshot>(
              stream: _discussionStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final discussionId = doc.id;

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('User')
                            .doc(globalUserId) // Fetching the current user's document
                            .get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final userDoc = userSnapshot.data!;
                          bool isLiked = (userDoc['likes'] ?? []).contains(discussionId);
                          bool isFavorited = (userDoc['favourites'] ?? []).contains(discussionId);

                          String profileInitial = doc['creator']?.substring(0, 1).toUpperCase() ?? '';

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                            elevation: 2, // Add elevation for shadow effect
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                              leading: CircleAvatar(
                                child: Text(profileInitial),
                              ),
                              title: Text(
                                doc['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc['description'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0), // Spacing between text and icons
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                                          color: isLiked ? Colors.blue : Colors.grey,
                                        ),
                                        onPressed: () => _toggleLike(discussionId, isLiked),
                                      ),
                                      Text('${doc['likesCount']}'),
                                      IconButton(
                                        icon: Icon(
                                          isFavorited ? Icons.favorite : Icons.favorite_border,
                                          color: isFavorited ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () => _toggleFavorite(discussionId, isFavorited),
                                      ),
                                      Text('${doc['favouritesCount']}'),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiscussionChat(
                                      discussionId: discussionId,
                                      creatorId: doc['createdBy'],
                                      creatorName: doc['creator'],
                                      currentUser: widget.currentUser,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDiscussion,
        child: const Icon(Icons.add),
      ),
    );
  }
}
