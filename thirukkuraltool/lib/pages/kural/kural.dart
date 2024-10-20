import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore package

class KuralPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subTitle; // 'from-to' format, e.g., '5-10'

  const KuralPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  _KuralPageState createState() => _KuralPageState();
}

class _KuralPageState extends State<KuralPage> {
  List<String> kurals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKurals();
  }

  Future<void> fetchKurals() async {
    try {
      // Parse the 'from-to' range from subTitle
      List<String> temp = widget.title.split(' ');
      List<String> range = temp[1].split('-');
      int start = int.parse(range[0].trim());
      int end = int.parse(range[1].trim());

      // Fetch kurals from Firestore collection 'Thirukkural'
      for (int i = start; i <= end; i++) {
        String key = i.toString();

        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('Thirukkural')
                .doc(key)
                .get();

        if (snapshot.exists) {
          String kural = snapshot.data()?['kural'] ?? 'Kural not found';
          kurals.add(kural);
        } else {
          kurals.add('Kural $key not found');
        }
      }
    } catch (e) {
      print('Error fetching kurals: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: kurals.length,
                      itemBuilder: (context, index) {
                        // Each kural is displayed in a styled card
                        return Card(
                          margin: const EdgeInsets.only(bottom: 15.0),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          221, 58, 109, 140),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${kurals[index].split('\$')[0]}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(221, 9, 16, 87),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  kurals[index].split('\$')[1],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: const Color.fromARGB(221, 9, 16, 87),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
