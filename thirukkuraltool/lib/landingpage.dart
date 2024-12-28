import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:thirukkuraltool/pages/contribution/ContributionHome.dart';
import 'package:thirukkuraltool/pages/discussion/discussion.dart';
import 'package:thirukkuraltool/pages/kural/kural.dart';
import 'package:thirukkuraltool/pages/profile/profile.dart';
import 'package:thirukkuraltool/pages/query_content_gen/querycontentgen.dart';
import 'package:thirukkuraltool/pages/search/search.dart';
import 'globals.dart';
import 'pages/authentication/login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ThirukkuralHome(
        onPressed: (context, imagePath, title, subTitle, list) {
          print('hello everyone');
          updatestate(imagePath, title, subTitle, list);
        },
      ),
      Discussion(
        currentUser: globalUsername ?? 'UserName',
      ),
      QueryContentGen(),
      ContributionsPage(),
      KuralPage(
          imagePath: "adhigaram_1.png",
          title: 'குறள் 1-10',
          subTitle: 'அதிகாரம் 1',
          list: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
    ];
  }

  void updatestate(
      String imagePath, String title, String subTitle, List<int> list) {
    print('heeeee');

    setState(() {
      _pages[_pages.length - 1] = KuralPage(
        imagePath: imagePath,
        title: title,
        subTitle: subTitle,
        list: list,
      );
      _selectedIndex = _pages.length - 1;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      globalUserId = null;
      globalUsername = null;
      Navigator.of(context).pushReplacementNamed('/signin');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void _onItemTapped(int index) {
    print(index);
    setState(() {
      _selectedIndex = index;
    });
    print(_pages[_selectedIndex].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 237, 160, 96),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/vector.png'),
            ),
            SizedBox(width: 10),
            Text(globalUsername ?? 'UserName',
                style: TextStyle(
                  color: Color.fromARGB(255, 228, 228, 239),
                )),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () => {},
            ),
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () => {}
                // _signOut(context),
                ),
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () => {
                      _signOut(context),
                    }
                //  _signOut(context),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.double_arrow),
            label: 'Contribute',
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

class ThirukkuralHome extends StatelessWidget {
  final Function(
    BuildContext context,
    String imagePath,
    String title,
    String titleSubTitle,
    List<int> list,
  ) onPressed;

  const ThirukkuralHome({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
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
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Master ',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Thirukkural',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' with in-depth word-by-word insights.',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 43,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.white,
                    //     spreadRadius: 2,
                    //     blurRadius: 5,
                    //     offset: Offset(0, 3),
                    //   ),
                    // ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Search()),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Search...                   ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.27,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => {
                          onPressed(context, 'assets/chuvadi.png',
                              'subadhigaram', 'name', [15, 20, 24, 36])
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red, Colors.orange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              'Standard ${index + 1}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 25,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, index) {
                          return ThirukkuralCard(
                              imagePath: 'assets/adhigaram_${index + 1}.png',
                              title:
                                  'குறள் ${(index + 1) * 10 - 9}-${(index + 1) * 10}',
                              subTitle: 'அதிகாரம் ${index + 1}',
                              onCardTap: onPressed);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ThirukkuralCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;

  final Function(BuildContext context, String imagePath, String title,
      String subTitle, List<int> list) onCardTap;

  const ThirukkuralCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.onCardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('heellooo');
        List<int> list = [
          for (int i = int.parse(title.split(' ')[1].split('-')[0]);
              i < int.parse(title.split(' ')[1].split('-')[0]) + 10;
              i++)
            i
        ];
        print(list);
        onCardTap(context, imagePath, title, subTitle, list);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subTitle,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
