import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thirukkuraltool/landingpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/authentication/login.dart';
import 'Pages/authentication/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/signin': (context) => SignInPage(),
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }

            if (snapshot.hasData) {
              return HomePage();
            } else {
              return SignInPage();
            }
          },
        ));
  }

  Future<void> _showWordOfTheDayDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text("New word to learn"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Thirukkural"),
              SizedBox(height: 10),
              Text(
                "Explanation of the word in this context.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// void main() {
//   runApp(VideoScrollerApp());
// }

// class VideoScrollerApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: VideoScroller(),
//     );
//   }
// }

// class VideoScroller extends StatefulWidget {
//   @override
//   _VideoScrollerState createState() => _VideoScrollerState();
// }

// class _VideoScrollerState extends State<VideoScroller> {
//   final List<String> videos = [
//     'assets/video1.mp4',
//     'assets/video1.mp4',
//     'assets/video1.mp4',
//     'assets/video1.mp4',
//     'assets/video1.mp4',
//     'assets/video1.mp4',
//     'assets/video1.mp4',
//     'assets/video1.mp4',
//     'assets/video1.mp4',
//     'assets/video1.mp4',
//   ];

//   PageController _pageController = PageController();
//   VideoPlayerController? _videoController;
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo(currentIndex);

//     _pageController.addListener(() {
//       int newIndex = _pageController.page!.round();
//       if (newIndex != currentIndex) {
//         setState(() {
//           currentIndex = newIndex % videos.length;
//         });
//         _initializeVideo(currentIndex);
//       }
//     });
//   }

//   void _initializeVideo(int index) {
//     _videoController?.dispose();
//     _videoController = VideoPlayerController.asset(videos[index])
//       ..initialize().then((_) {
//         setState(() {});
//         _videoController!.play();
//         _videoController!.setLooping(true);
//       });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _videoController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView.builder(
//         controller: _pageController,
//         scrollDirection: Axis.vertical,
//         itemBuilder: (context, index) {
//           int videoIndex = index % videos.length;
//           return VideoPage(
//             videoController:
//                 videoIndex == currentIndex ? _videoController : null,
//             videoPath: videos[videoIndex],
//             onTap: () {
//               if (_videoController != null &&
//                   _videoController!.value.isPlaying) {
//                 _videoController!.pause();
//               } else {
//                 _videoController!.play();
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class VideoPage extends StatelessWidget {
//   final VideoPlayerController? videoController;
//   final String videoPath;
//   final VoidCallback onTap;

//   const VideoPage({
//     Key? key,
//     this.videoController,
//     required this.videoPath,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         color: Colors.black,
//         child: Center(
//           child: videoController != null && videoController!.value.isInitialized
//               ? AspectRatio(
//                   aspectRatio: videoController!.value.aspectRatio,
//                   child: VideoPlayer(videoController!),
//                 )
//               : CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
// }
