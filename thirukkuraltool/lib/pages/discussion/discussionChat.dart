import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thirukkuraltool/globals.dart';

class DiscussionChat extends StatefulWidget {
  final String discussionId;
  final String currentUser;

  const DiscussionChat({
    Key? key,
    required this.discussionId,
    required this.currentUser, required creatorId, required creatorName,
  }) : super(key: key);

  @override
  _DiscussionChatState createState() => _DiscussionChatState();
}

class _DiscussionChatState extends State<DiscussionChat> {
  final TextEditingController _messageController = TextEditingController();
  late CollectionReference messagesRef;

  @override
  void initState() {
    super.initState();
    // Initialize the messages collection reference
    messagesRef = FirebaseFirestore.instance
        .collection('Discussion')
        .doc(widget.discussionId)
        .collection('messages');
  }

  // Function to send a new message
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      try {
        await messagesRef.add({
          'userID': globalUserId,
          'username': globalUsername, // Replace with actual username if available
          'message': _messageController.text.trim(),
          'timestamp': Timestamp.now(),
        });
        _messageController.clear();
      } catch (e) {
        print("Error sending message: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef.orderBy('timestamp', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading messages'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    bool isCurrentUser = message['userID'] == globalUserId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment:
                            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isCurrentUser)
                            CircleAvatar(
                              child: Text(message['username'][0].toUpperCase()),
                            ),
                          const SizedBox(width: 8),
                          Flexible(  // Wraps message content to avoid overflow
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isCurrentUser ? 'You' : message['username'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: isCurrentUser ? Colors.orange.shade100 : Colors.orange.shade200,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                  child: Text(
                                    message['message'],
                                    textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  (message['timestamp'] as Timestamp)
                                      .toDate()
                                      .toLocal()
                                      .toString()
                                      .substring(0, 16),
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  );
                  },
                );

              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Your thoughts...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
