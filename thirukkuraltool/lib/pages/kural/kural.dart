import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thirukkuraltool/pages/kural/individualkural.dart';

class KuralPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subTitle;

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
  int start = 0;
  int end = 0;

  @override
  void initState() {
    super.initState();
    fetchKurals();
  }

  Future<void> fetchKurals() async {
    try {
      List<String> range = widget.title.split(' ')[1].split('-');
      start = int.parse(range[0]);
      end = int.parse(range[1]);
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
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Content: List of Kurals in Cards
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: kurals.length,
                      itemBuilder: (context, index) {
                        return KuralCard(
                          index: start + index,
                          kuralText: kurals[index],
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

class KuralCard extends StatelessWidget {
  final int index;
  final String kuralText;

  const KuralCard({
    Key? key,
    required this.index,
    required this.kuralText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Kural(
              kuralIndex: index,
              kuralText: kuralText,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.8),
            width: 2,
          ),
        ),
        margin: const EdgeInsets.only(bottom: 15.0),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                kuralText.split('\$')[0],
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2),
              Text(
                kuralText.split('\$')[1],
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
