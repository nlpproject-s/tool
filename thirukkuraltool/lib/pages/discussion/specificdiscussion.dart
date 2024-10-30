import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SpecificDialog extends StatefulWidget {
  final String currentUser;
  const SpecificDialog({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SpecificDialog createState() => _SpecificDialog();
}

class _SpecificDialog extends State<SpecificDialog> {
  late Stream<QuerySnapshot> _discussionStream;

  @override
  void initState() {
    super.initState();
    _discussionStream =
        FirebaseFirestore.instance.collection("Discussion").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrangeAccent, Colors.orangeAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _discussionStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No discussions found.'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final username = data['username'] as String;
                final time = data['time'] as String;
                final content = data['content'] as String;

                return DiscussionCard(
                  username: username,
                  time: time,
                  content: content,
                  isCurrentUser: username == widget.currentUser,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DiscussionCard extends StatelessWidget {
  final String username;
  final String time;
  final String content;
  final bool isCurrentUser;

  const DiscussionCard({
    Key? key,
    required this.username,
    required this.time,
    required this.content,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        color: isCurrentUser ? Colors.deepOrange[100] : Colors.white,
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              SizedBox(height: 5),
              Text(
                content,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 5),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
