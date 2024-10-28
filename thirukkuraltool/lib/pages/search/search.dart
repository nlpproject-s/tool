import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thirukkuraltool/pages/kural/individualkural.dart';
import 'package:thirukkuraltool/pages/kural/kural.dart';
import 'package:thirukkuraltool/pages/profile/profile.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  late QuerySnapshot querySnapshot;
  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    querySnapshot =
        await FirebaseFirestore.instance.collection("TopicSearch").get();
  }

  Future<void> fetchData(String topic) async {
    results.clear();
    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final englishTopics = List<String>.from(data['topics']['english'] ?? []);
      for (var word in englishTopics) {
        if (word.toLowerCase().startsWith(topic.toLowerCase())) {
          results.add({
            'kuralNumber': data['adhigaram']['number']?.toString() ?? "0",
            'title': data['adhigaram']['english'] ?? "No Title",
            'kural': data['kural'] ?? "No Kural text available",
          });
        }
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
                      print('hellllo');
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
                child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final temp = _searchResults[index];
                return SearchResultCard(
                  kuralNumber: temp['kuralNumber'],
                  title: temp['title'],
                  kural: temp['kural'],
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  final String kuralNumber;
  final String title;
  final String? kural;

  const SearchResultCard({
    Key? key,
    required this.kuralNumber,
    required this.title,
    this.kural,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('\n\ninside');
        Navigator.push(
          context,
          MaterialPageRoute(
            // builder: (context) => Kural(
            //   kuralIndex: 10,
            //   kuralText: "No Kural text available",
            // ),
            builder: (context) => KuralPage(
                imagePath: "assets/orange_grad.png",
                title: "title",
                subTitle: "subTitle",
                list: [int.parse(kuralNumber)]),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kural Number: $kuralNumber",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Title: $title",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              if (kural != null && kural!.isNotEmpty)
                Text(
                  "Kural: $kural",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
