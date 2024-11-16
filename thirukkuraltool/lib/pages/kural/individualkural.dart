import 'dart:ui';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Kural extends StatefulWidget {
  final int kuralIndex;
  final String kuralText;
  const Kural({
    Key? key,
    required this.kuralIndex,
    required this.kuralText,
  }) : super(key: key);
  @override
  _Kural createState() => _Kural();
}

class _Kural extends State<Kural> {
  FlutterTts flutterTts = FlutterTts();
  Map<String, String> clickedWords = {};
  double height = 0;
  double width = 0;
  Future<String> fetchPorul() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Porul')
          .doc(widget.kuralIndex.toString())
          .get();

      if (snapshot.exists) {
        return snapshot.data()?['porul'] ??
            'அறம் பயக்கும் இனிய சொற்களும் தனக்கு உளவாயிருக்க அவற்றைக் கூறாது பாவம் ';
      } else {
        return 'அறம் பயக்கும் இனிய சொற்களும் தனக்கு உளவாயிருக்க அவற்றைக் கூறாது பாவம் ';
      }
    } catch (e) {
      return 'Error fetching porul';
    }
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
                fontSize: 16,
                color: Colors.white,
                // decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> fetchWordMeaning(String word) async {
    String predictedMeaning = 'meaning';

    setState(() {
      clickedWords[word] = predictedMeaning;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/tamil_1.png',
              fit: BoxFit.cover,
            ),
          ),
          // Positioned.fill(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [
          //           Color.fromARGB(255, 235, 179, 94),
          //           Colors.white,
          //           Color.fromARGB(255, 235, 179, 94),
          //         ],
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         stops: [0.0, 0.5, 1.0],
          //       ),
          //     ),
          //   ),
          // ),
          SingleChildScrollView(
            child: Column(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(
                              'Kural ${widget.kuralIndex}',
                              style: TextStyle(
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tirukkural',
                              style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Container(
                              width: width * 0.9,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.8),
                                  width: 3.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, 4),
                                    blurRadius: 8.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildClickableText(
                                      widget.kuralText.split('\$')[0]),
                                  _buildClickableText(
                                      widget.kuralText.split('\$')[1]),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Lemma')
                                .doc(widget.kuralIndex.toString())
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Center(
                                    child: Text('No Lemma available.'));
                              }
                              var document = snapshot.data!;
                              var lemmaData =
                                  document.data() as Map<String, dynamic>;
                              var lemmaText = lemmaData.values.first;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lemmma easy to read',
                                    style: TextStyle(
                                      fontSize: width * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    width: width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildClickableText(lemmaText)
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                        SizedBox(height: height * 0.02),
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
                                  fontSize: width * 0.04,
                                ),
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meaning',
                                    style: TextStyle(
                                      fontSize: width * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lime,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    width: width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildClickableText('${snapshot.data}')
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Clicked Words and Meanings',
                                style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              SizedBox(height: height * 0.02),
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
                                height: height * 0.35,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Colors.orangeAccent,
                                        padding: EdgeInsets.symmetric(
                                            vertical: height * 0.02),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Center(
                                                    child: Text(
                                              'Word',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.brown,
                                              ),
                                            ))),
                                            Expanded(
                                                child: Center(
                                                    child: Text(
                                              'Meaning',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.brown,
                                              ),
                                            ))),
                                            Expanded(
                                                child: Center(
                                                    child: Text(
                                              'Aloud',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.brown,
                                              ),
                                            ))),
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
                                            String meaning =
                                                clickedWords[word]!;
                                            return ListTile(
                                              title: Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                    word,
                                                    style: TextStyle(
                                                        fontSize: width * 0.04,
                                                        color:
                                                            Colors.blueAccent),
                                                  )),
                                                  Expanded(
                                                      child: Text(
                                                    meaning,
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.white,
                                                      fontSize: width * 0.04,
                                                    ),
                                                  )),
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.volume_down_sharp,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 215, 86, 77)),
                                                    onPressed: () {
                                                      // setState(() {
                                                      //   clickedWords
                                                      //       .remove(word);
                                                      // });
                                                      String spacedText =
                                                          "இருவினையும்"
                                                                  .characters
                                                                  .map((ch) =>
                                                                      '$ch ')
                                                                  .join() +
                                                              'இருவினையும் ';

                                                      _speakText(spacedText);
                                                    },
                                                  ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _speakText(String word) async {
    print('hello everyone of you');
    await flutterTts.setLanguage("ta-IN");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.3);
    List<String> st = word.split(' ');
    for (var ch in st) {
      _showPopup(ch);
      await flutterTts.speak(ch);
      await flutterTts.awaitSpeakCompletion(true);
      Navigator.of(context).pop();
    }
    // Navigator.of(context).pop();
  }

  void _showPopup(String ch) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: height,
            width: width,
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.pinkAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 4),
                ),
              ],
              border: Border.all(
                color: Colors.deepOrange,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                ch,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.black45,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
