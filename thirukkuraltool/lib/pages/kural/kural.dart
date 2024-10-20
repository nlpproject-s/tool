import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thirukkuraltool/landingpage.dart';
import 'package:thirukkuraltool/pages/discussion/discussion.dart';
import 'package:thirukkuraltool/pages/like/likepage.dart';
import 'package:thirukkuraltool/pages/profile/profile.dart';
import 'package:thirukkuraltool/pages/query_content_gen/querycontentgen.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _username = '';
  late List<Widget> _pages;
  int _selectedIndex = 5;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _pages = [
      ThirukkuralHome(),
      Discussion(),
      LikePage(),
      QueryContentGen(),
      Profile(),
      ActualKuralPage(
          imagePath: widget.imagePath,
          title: widget.title,
          subTitle: widget.subTitle),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String email = user.email ?? '';
      setState(() {
        _username = email.split('@')[0];
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/signin');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 237, 160, 96),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/vector.png'),
            ),
            SizedBox(width: 10),
            Text(_username.isNotEmpty ? _username : 'User',
                style: TextStyle(
                  color: Color.fromARGB(255, 228, 228, 239),
                )),
            Spacer(),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Discussions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'kural',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 0, 50, 133),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class ActualKuralPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subTitle;

  const ActualKuralPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  _ActualKuralPageState createState() => _ActualKuralPageState();
}

class _ActualKuralPageState extends State<ActualKuralPage> {
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
          // Background Image - stays fixed
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
                                    '${start + index}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        // color: const Color.fromARGB(221, 58, 109, 140),
                                        color: Colors.white),
                                  ),
                                ),
                                Text(
                                  '${kurals[index].split('\$')[0]}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      // fontWeight: FontWeight.bold,
                                      // color: const Color.fromARGB(221, 58, 109, 140),
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  kurals[index].split('\$')[1],
                                  style: TextStyle(
                                      fontSize: 18,
                                      // color: const Color.fromARGB(221, 58, 109, 140),
                                      color: Colors.white),
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
