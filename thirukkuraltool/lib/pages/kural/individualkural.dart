import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore integration
class Kural extends StatefulWidget {
  @override
  _Kural createState() => _Kural();
}

class _Kural extends State<Kural> {
  String? selectedAdhigaram;
  String? selectedKuralNumber;
  Map<String, String> clickedWords = {};


  // Future<String> fetchPorul() async {
  //   try {
  //     DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
  //         .instance
  //         .collection('Porul')
  //         .doc(kuralIndex.toString())
  //         .get();

  //     if (snapshot.exists) {
  //       return snapshot.data()?['porul'] ?? 'Porul not available';
  //     } else {
  //       return 'Porul not available';
  //     }
  //   } catch (e) {
  //     return 'Error fetching porul';
  //   }
  // }
  Future<void> fetchWordMeaning(String word) async {
    
      String predictedMeaning = 'meaning';

      setState(() {
        clickedWords[word] = predictedMeaning;
      });
    } 
    
      @override
      State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
      }
      
        @override
        Widget build(BuildContext context) {
          // TODO: implement build
          throw UnimplementedError();
        }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    String? selectedKuralNumber;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/tamil_1.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.6), // Adjust opacity here
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40), // Space for the app bar height
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Kural $kuralIndex',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ), Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: selectedKuralNumber,
                          hint: Text('Select Kural Number'),
                          isExpanded: true,
                          items: _getKuralNumbers(selectedAdhigaram!)
                              .map((String kural) {
                            return DropdownMenuItem<String>(
                              value: kural,
                              child: Text(kural),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedKuralNumber = newValue;
                              clickedWords.clear();
                            });
                          },
                        ),
                      ),
                    if (selectedKuralNumber != null)
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Tirukural')
                            .doc(selectedKuralNumber)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Center(child: Text('No Kural available.'));
                          }

                          var document = snapshot.data!;
                          var kuralData =
                              document.data() as Map<String, dynamic>;
                          var kuralText = kuralData.values.first;
                          var splitKuralText = kuralText.split(r'$');

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tirukkural',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              _buildClickableText(splitKuralText[0]),
                              _buildClickableText(splitKuralText[1]),
                            ],
                          );
                        },
                      ),
                    SizedBox(height: 20),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Lemma')
                          .doc(selectedKuralNumber)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Center(child: Text('No Lemma available.'));
                        }
                        var document = snapshot.data!;
                        var lemmaData = document.data() as Map<String, dynamic>;
                        var lemmaText = lemmaData.values.first;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lemma easy to read',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              _buildClickableText(lemmaText),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    if (clickedWords.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Clicked Words and Meanings:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1.5),
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: 450,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.teal.withOpacity(0.1),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Center(
                                                  child: Text('Word',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold)))),
                                          Expanded(
                                              child: Center(
                                                  child: Text('Meaning',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold)))),
                                          Expanded(
                                              child: Center(
                                                  child: Text('Delete',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold)))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: clickedWords.length,
                                        itemBuilder: (context, index) {
                                          List<String> reversedKeys =
                                              clickedWords.keys
                                                  .toList()
                                                  .reversed
                                                  .toList();
                                          String word = reversedKeys[index];
                                          String meaning = clickedWords[word]!;
                                          return ListTile(
                                            title: Row(
                                              children: [
                                                Expanded(child: Text(word)),
                                                Expanded(
                                                    child: Text(
                                                  meaning,
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.grey),
                                                )),
                                                IconButton(
                                                  icon: Icon(Icons.delete,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    setState(() {
                                                      clickedWords.remove(word);
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: IconButton(
              icon: Icon(Icons.chat_bubble, size: 30, color: Colors.teal),
              onPressed: () {
                // Action for chat bubble button
              },
            ),
          ),
                      SizedBox(width: 50), // Extra space
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kural text
                        Text(
                          kuralText.split('\$')[0],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          kuralText.split('\$')[1],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Fetching Porul from Firestore
                        FutureBuilder<String>(
                          future: fetchPorul(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              );
                            } else {
                              return Text(
                                'Porul: ${snapshot.data}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  List<String> _getKuralNumbers(String adhigaram) {
    int start = adhigaramRanges[adhigaram]!['start']!;
    int end = adhigaramRanges[adhigaram]!['end']!;
    return List<String>.generate(
      end - start + 1,
      (index) => (start + index).toString(),
    );
  }

  Widget _buildClickableText(String text) {
    final words = text.split(' ');

    return Wrap(
      spacing: 1,
      runSpacing: 1,
      children: words.map((word) {
        return InkWell(
          onTap: () {
            fetchWordMeaning(word);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              word,
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
                decoration:
                    TextDecoration.underline, // Underline clickable text
                fontWeight: FontWeight.bold, // Bold for emphasis
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
