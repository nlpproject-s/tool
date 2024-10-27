// import 'dart:async';

// import 'package:flutter/material.dart';

// class Search extends StatefulWidget {
//   const Search({Key? key}) : super(key: key);

//   @override
//   _SearchState createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   TextEditingController _controller = TextEditingController();

//   void _onTextChanged(String text) {
//     print("Current input: $text");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Explore Kural"),
//         backgroundColor: Colors.deepOrange,
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.deepOrangeAccent, Colors.orangeAccent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.4),
//                   spreadRadius: 2,
//                   blurRadius: 7,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     onChanged: _onTextChanged,
//                     decoration: InputDecoration(
//                       hintText: "Which Kural would you like to explore?",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _controller.clear();
//                   },
//                   child: Icon(Icons.clear, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> fetchData(String topic) async {
    final results = <Map<String, dynamic>>[];
    final querySnapshot =
        await FirebaseFirestore.instance.collection("TopicSearch").get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final englishTopics = List<String>.from(data['doc_1']['english']);

      if (englishTopics.contains(topic)) {
        results.add({
          'kuralNumber': data['adhigaram']['number'],
          'title': data['adhigaram']['english'],
        });
      }
    }

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Kural"),
        backgroundColor: Colors.deepOrange,
      ),
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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        if (value.trim().isNotEmpty) {
                          fetchData(value.trim());
                        } else {
                          setState(() {
                            _searchResults = [];
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Which Kural would you like to explore?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _controller.clear();
                      setState(() {
                        _searchResults = [];
                      });
                    },
                    child: Icon(Icons.clear, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return ListTile(
                          title: Text(
                            "Kural Number: ${result['kuralNumber']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            "Title: ${result['title']}",
                            style: TextStyle(color: Colors.black54),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No results found.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
