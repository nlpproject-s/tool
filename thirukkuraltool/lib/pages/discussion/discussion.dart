// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Discussion extends StatefulWidget {
//   @override
//   _Discussion createState() => _Discussion();
// }

// class _Discussion extends State<Discussion> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   int _selectedIndex = 0;
//   String _username = '';
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       String email = user.email ?? '';
//       setState(() {
//         _username = email.split('@')[0];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    // _discussionStream =
    //     FirebaseFirestore.instance.collection("Discussion").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            // Add your search logic here
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'All Discussions') {
                // Implement logic for All Discussions
              } else if (value == 'Create New') {
                _showCreateDiscussionDialog(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'All Discussions',
                child: Text('All Discussions'),
              ),
              PopupMenuItem(
                value: 'Create New',
                child: Text('Create New'),
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [Text("you are not in any of the discussion")],
      ),
    );
  }

  void _showCreateDiscussionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                final title = titleController.text;
                final description = descriptionController.text;
                DocumentReference docRef = await FirebaseFirestore.instance
                    .collection('Discussion')
                    .add({
                  'title': title,
                  'description': description,
                  'createdAt': Timestamp.now(),
                });
                await FirebaseFirestore.instance
                    .collection('SpecificDiscussion')
                    .doc(docRef.id)
                    .set({});

                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
