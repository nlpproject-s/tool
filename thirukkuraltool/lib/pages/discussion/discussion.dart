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
  String? _selectedLiterature; // State variable for selected literature
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
      String searchQueryLowerCase = _searchQuery.toLowerCase();

      query = query
          .where('title', isGreaterThanOrEqualTo: searchQueryLowerCase)
          .where('title', isLessThanOrEqualTo: '$searchQueryLowerCase\uf8ff');
    }

    // Apply literature filter if selected
    if (_selectedLiterature != null) {
      query = query.where("literature", isEqualTo: _selectedLiterature!.toLowerCase());
    }

    _discussionStream = query.snapshots();
  });
}

  // Add new discussion dialog
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
    body:Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.orangeAccent.withOpacity(0.8),
        Colors.transparent,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  ),
  child: Column(
    children: [
      // Search bar
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            _filterDiscussions();
          },
          decoration: InputDecoration(
            hintText: 'Search',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0), 
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        // My Discussions button
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                // Toggle "My Discussions" filter
                _selectedLiterature = (_selectedLiterature == 'My Discussions') ? null : 'My Discussions';
              });
              if (_selectedLiterature == 'My Discussions') {
                _discussionStream = FirebaseFirestore.instance
                    .collection("Discussion")
                    .where("createdBy", isEqualTo: globalUserId)
                    .snapshots();
              } else {
                _discussionStream = FirebaseFirestore.instance.collection("Discussion").snapshots();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                gradient: _selectedLiterature == 'My Discussions'
                    ? const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 0, 121, 28),
                          Color.fromARGB(255, 0, 203, 47),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Colors.red, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  'My Discussions',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Literature filters
        ...literatures.map((literature) {
          final isSelected = _selectedLiterature == literature;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  // Toggle selection
                  _selectedLiterature = (_selectedLiterature == literature) ? null : literature;
                });
                _filterDiscussions();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 0, 121, 28),
                            Color.fromARGB(255, 0, 203, 47),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [Colors.red, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    literature,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    ),
  ),
),
const SizedBox(height: 16.0),
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
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    ],
  ),
),
floatingActionButton: FloatingActionButton(
  onPressed: _addNewDiscussion,
  backgroundColor: Colors.orange,
  child: const Icon(Icons.add, color: Colors.white),
),
);
  }

  // Toggle like status
  Future<void> _toggleLike(String discussionId, bool isLiked) async {
    final userRef = FirebaseFirestore.instance.collection('User').doc(globalUserId);

    if (isLiked) {
      await userRef.update({
        'likes': FieldValue.arrayRemove([discussionId]),
      });
      await FirebaseFirestore.instance.collection('Discussion').doc(discussionId).update({
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      await userRef.update({
        'likes': FieldValue.arrayUnion([discussionId]),
      });
      await FirebaseFirestore.instance.collection('Discussion').doc(discussionId).update({
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  // Toggle favorite status
  Future<void> _toggleFavorite(String discussionId, bool isFavorited) async {
    final userRef = FirebaseFirestore.instance.collection('User').doc(globalUserId);

    if (isFavorited) {
      await userRef.update({
        'favourites': FieldValue.arrayRemove([discussionId]),
      });
      await FirebaseFirestore.instance.collection('Discussion').doc(discussionId).update({
        'favouritesCount': FieldValue.increment(-1),
      });
    } else {
      await userRef.update({
        'favourites': FieldValue.arrayUnion([discussionId]),
      });
      await FirebaseFirestore.instance.collection('Discussion').doc(discussionId).update({
        'favouritesCount': FieldValue.increment(1),
      });
    }
  }
}
