import 'package:flutter/material.dart';

class ContributionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Text(
                    "07:00 AM",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Text(
                  "Hello!",
                  style: TextStyle(
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  "Explore Contributions & Insights",
                  style: TextStyle(
                    fontSize: width * 0.045,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: height * 0.02),

                // Literatures Section
                Text(
                  "Literatures",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.01),
                SizedBox(
                  height: height * 0.15,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _literatureCard("Thirukkural", "assets/thirukkural.png"),
                      _literatureCard(
                          "Silapathikaram", "assets/silapathikaram.png"),
                      _literatureCard("Tolkappiyam", "assets/tolkappiyam.png"),
                      _literatureCard("Ettutogai", "assets/ettutogai.png"),
                      _literatureCard("Pattupattu", "assets/pattupattu.png"),
                      _literatureCard("+", "assets/add.png"),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),

                // Contributions Section
                Text(
                  "Contributions",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Row(
                  children: [
                    _tabButton("Popular", Icons.star),
                    _tabButton("Trending", Icons.trending_up),
                    _tabButton("Featured", Icons.featured_play_list),
                    _tabButton("Latest", Icons.new_releases),
                  ],
                ),
                SizedBox(height: height * 0.02),

                // Contribution Cards
                _contributionCard(context),
                SizedBox(height: height * 0.02),
                _contributionCard(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _literatureCard(String title, String assetPath) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(assetPath),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String title, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.black),
            SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contributionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 30),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Designation",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              Spacer(),
              Text(
                "Contributed a month ago",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '"The Power of Fate in Silapathikaram: Kannagi’s Transformative Journey"',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 5),
              Text("200"),
              SizedBox(width: 10),
              Icon(Icons.verified, color: Colors.green),
              SizedBox(width: 5),
              Text("Verified by"),
              SizedBox(width: 5),
              CircleAvatar(radius: 10, backgroundColor: Colors.blue),
              CircleAvatar(radius: 10, backgroundColor: Colors.green),
              CircleAvatar(radius: 10, backgroundColor: Colors.orange),
              CircleAvatar(radius: 10, backgroundColor: Colors.pink),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  print("Read More");
                },
                child: Text("Read More"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ""),
      ],
      selectedItemColor: Colors.purple,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContributionsPage(),
  ));
}
