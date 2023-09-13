import 'package:flutter/material.dart';
import 'package:interactive_video/screens/video_player.dart';
import 'package:video_player/video_player.dart';

import 'screens/merged_video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FullScreenVideoPlayer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VideoPlayer1 extends StatefulWidget {
  @override
  _VideoPlayer1State createState() => _VideoPlayer1State();
}

class _VideoPlayer1State extends State<VideoPlayer1> {
  late VideoPlayerController _controller;
  int selectedTileIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/merged.mp4',
    )..initialize().then((_) {
        setState(() {});
      });
  }

  void showSeekOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white.withOpacity(0.5),
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.only(left: 100, right: 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Which option are you interested in seeing next?",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Water falls'),
                  onTap: () {
                    Future.delayed(const Duration(seconds: 6), () {
                      _controller.seekTo(const Duration(seconds: 20));
                      Navigator.of(context).pop();
                    });
                  },
                ),
                ListTile(
                  title: const Text('Beach'),
                  onTap: () {
                    Future.delayed(const Duration(seconds: 6), () {
                      _controller.seekTo(const Duration(seconds: 30));
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: 2.035,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.play();
            Future.delayed(const Duration(seconds: 12), () {
              showSeekOptions();
            });
          },
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
