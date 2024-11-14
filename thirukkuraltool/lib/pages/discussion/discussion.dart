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

  @override
  void initState() {
    super.initState();
    _discussionStream =
        FirebaseFirestore.instance.collection("Discussion").snapshots();
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
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController literatureController = TextEditingController();

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
                    'literature': literature,
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
        title: Text('Discussions'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewDiscussion, // Show dialog to create new discussion
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Discussions',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
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
                            .doc(globalUserId)  // Fetching the current user's document
                            .get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final userDoc = userSnapshot.data!;
                          bool isLiked = (userDoc['likes'] ?? []).contains(discussionId);
                          bool isFavorited = (userDoc['favourites'] ?? []).contains(discussionId);

                          String profileInitial = doc['creator']?.substring(0, 1).toUpperCase() ?? '';

                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(profileInitial), // Display the initial
                            ),
                            title: Text(doc['title']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doc['description']),
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DiscussionChat(
                                    discussionId: discussionId,
                                    creatorId: doc['createdBy'],  // The creator's user ID
                                    creatorName: doc['creator'], // The creator's name
                                    currentUser: widget.currentUser,
                                  ),
                                ),
                              );
                            },
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
          Divider(height: 2.0),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Literatures',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: literatures.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Chip(
                    label: Text(
                      literatures[index],
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.blueAccent,
                    shape: StadiumBorder(),
                  ),
                );
              },
            ),
          ),
          Divider(height: 2.0),
        ],
      ),
    );
  }
}
