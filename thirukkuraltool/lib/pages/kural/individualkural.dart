import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart'; // For Firestore integration

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
  // String? selectedAdhigaram;
  // String? selectedKuralNumber;
  Map<String, String> clickedWords = {};
  Future<String> fetchPorul() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Porul')
          .doc(widget.kuralIndex.toString())
          .get();

      if (snapshot.exists) {
        return snapshot.data()?['porul'] ??
            'அறம் பயக்கும் இனிய சொற்களும் தனக்கு உளவாயிருக்க அவற்றைக் கூறாது பாவம் பயக்கும் இன்னாத சொற்களை ஒருவன் கூறல், இனிய கனிகளும் தன் கைக்கண் உளவாயிருக்க அவற்றை நுகராது இன்னாத காய்களை நுகர்ந்ததனோடு ஒக்கும்.';
      } else {
        return 'அறம் பயக்கும் இனிய சொற்களும் தனக்கு உளவாயிருக்க அவற்றைக் கூறாது பாவம் பயக்கும் இன்னாத சொற்களை ஒருவன் கூறல், இனிய கனிகளும் தன் கைக்கண் உளவாயிருக்க அவற்றை நுகராது இன்னாத காய்களை நுகர்ந்ததனோடு ஒக்கும்.';
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
                color: const Color.fromARGB(255, 68, 146, 209),
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

  Future<void> fetchWordMeaning(String word) async {
    String predictedMeaning = 'meaning';

    setState(() {
      clickedWords[word] = predictedMeaning;
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
                  SizedBox(height: 40),
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tirukkural',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildClickableText(widget.kuralText.split('\$')[0]),
                      _buildClickableText(widget.kuralText.split('\$')[1]),
                    ],
                  ),
                  SizedBox(height: 20),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Lemma')
                        .doc(widget.kuralIndex.toString())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(child: Text('No Lemma available.'));
                      }
                      var document = snapshot.data!;
                      var lemmaData = document.data() as Map<String, dynamic>;
                      var lemmaText = lemmaData.values.first;
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lemma easy to read',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                          return Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Meaning',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                _buildClickableText('${snapshot.data}'),
                              ],
                            ),
                          );
                        }
                      }),
                  SizedBox(height: 20),
                  if (clickedWords.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Clicked Words and Meanings',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 20),
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
                            height: height * 0.3,
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors
                                                            .orangeAccent)))),
                                        Expanded(
                                            child: Center(
                                                child: Text('Meaning',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors
                                                            .orangeAccent)))),
                                        Expanded(
                                            child: Center(
                                                child: Text('Delete',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors
                                                            .orangeAccent)))),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: clickedWords.length,
                                      itemBuilder: (context, index) {
                                        List<String> reversedKeys = clickedWords
                                            .keys
                                            .toList()
                                            .reversed
                                            .toList();
                                        String word = reversedKeys[index];
                                        String meaning = clickedWords[word]!;
                                        return ListTile(
                                          title: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                word,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.blueAccent),
                                              )),
                                              Expanded(
                                                  child: Text(
                                                meaning,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              )),
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: const Color.fromARGB(
                                                        255, 215, 86, 77)),
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
          // Positioned(
          //   bottom: 1,
          //   right: 1,
          //   child: IconButton(
          //     icon: Icon(Icons.chat_bubble, size: 30, color: Colors.teal),
          //     onPressed: () {
          //       // Action for chat bubble button
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
